package manifest

import (
	"fmt"
	"io"
	"log/slog"
	"os"

	"gopkg.in/yaml.v3"
)

type Manifest struct {
	Refs     map[string]*TargetRef `yaml:"targets"`
	Resolved map[string]*Target
	log      *slog.Logger
}

func New(path string, output io.Writer, logLevel slog.Level) (*Manifest, error) {
	rawManifest, err := os.ReadFile(path)
	if err != nil {
		return nil, fmt.Errorf("failure reading manifest: %w", err)
	}
	level := new(slog.LevelVar)
	level.Set(logLevel)
	m := &Manifest{
		Resolved: map[string]*Target{},
		log: slog.New(slog.NewTextHandler(output, &slog.HandlerOptions{
			Level: level,
		})),
	}
	if err = yaml.Unmarshal(rawManifest, m); err != nil {
		return nil, fmt.Errorf("failure loading manifest: %w", err)
	}
	if err = m.resolveRefs(); err != nil {
		return nil, err
	}
	return m, nil
}

func (m *Manifest) Bytes() []byte {
	result, err := yaml.Marshal(m.Resolved)
	if err != nil {
		return []byte(err.Error())
	}
	return result
}

func (m *Manifest) String() string {
	return string(m.Bytes())
}

func (m *Manifest) resolveRefs() error {
	for name, ref := range m.Refs {
		if err := ref.validate(); err != nil {
			return fmt.Errorf("invalid key %s: %w", name, err)
		}
	}
	m.log.Debug("starting ref resolution")
	for name, ref := range m.Refs {
		ref.parent = name
		m.log.Debug(fmt.Sprintf("start %s", name))
		target, err := ref.build(m, 0)
		if err != nil {
			return fmt.Errorf("failure processing group %v: %w", name, err)
		}
		m.log.Debug(fmt.Sprintf("done %s", name))
		m.Resolved[name] = target
	}
	return nil
}

type TargetRef struct {
	parent     string
	Group      []string
	Workspaces []string
	Next       *TargetRef
}

func (ref *TargetRef) validate() error {
	if len(ref.Group) != 0 && len(ref.Workspaces) != 0 {
		return fmt.Errorf("workspaces and Group at same level")
	}
	return nil
}

func (ref *TargetRef) build(m *Manifest, depth int) (*Target, error) {
	target := &Target{Workspaces: ref.Workspaces}
	var err error
	if ref.Group != nil {
		if target.Group, err = ref.resolve(m, depth); err != nil {
			return nil, err
		}
	}
	if ref.Next != nil {
		ref.Next.parent = ref.parent
		if target.Next, err = ref.Next.build(m, depth+1); err != nil {
			return nil, err
		}
	}
	return target, nil
}

func (ref *TargetRef) resolve(m *Manifest, depth int) ([]*Target, error) {
	var children []*Target
	for _, name := range ref.Group {
		if resolved, ok := m.Resolved[name]; ok {
			children = append(children, resolved)
			continue
		}
		if unresolvedGroup, ok := m.Refs[name]; ok {
			group, err := unresolvedGroup.build(m, depth)
			if err != nil {
				return nil, err
			}
			children = append(children, group)
		} else {
			return nil, fmt.Errorf("group %v does not exist", name)
		}
	}
	return children, nil
}

func (m *Manifest) Target(name string) (*Target, error) {
	target, ok := m.Resolved[name]
	if !ok {
		return nil, fmt.Errorf("target %s not found", name)
	}
	return target, nil
}
