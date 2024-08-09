package manifest

import (
	"strings"

	"gopkg.in/yaml.v3"
)

type Target struct {
	Group      []*Target `yaml:"group,omitempty"`
	Workspaces []string  `yaml:"workspaces,omitempty"`
	Next       *Target   `yaml:"next,omitempty"`
}

func (t *Target) String() string {
	result, err := yaml.Marshal(t)
	if err != nil {
		return err.Error()
	}
	return string(result)
}

func (t *Target) Render() string {
	clone := t.clone()
	clone.adjustNextDepth()
	return strings.Join(clone.collapse().format(), "\n")
}

// When there is a `next` sibling to `group` it must be moved below the deepest
// "next" level of the child groups to ensure when the target is flattened the
// "next" task actually executes after the groups finish.
func (t *Target) adjustNextDepth() {
	if len(t.Group) > 0 && t.Next != nil {
		for range t.groupMaxNextDepth() {
			t.Next = &Target{Next: t.Next}
		}
	}
	for _, group := range t.Group {
		group.adjustNextDepth()
	}
}

func (t *Target) groupMaxNextDepth() int {
	maxDepth := 0
	for _, sub := range t.Group {
		depth := 0
		for curr := sub.Next; curr != nil; curr = curr.Next {
			depth++
		}
		if depth > maxDepth {
			maxDepth = depth
		}
	}
	return maxDepth
}

func (t *Target) collapse() *Target {
	levels := make(map[int][]string)
	t.collect(0, levels)
	return collapse(levels, 0)
}

func (t *Target) collect(level int, levels map[int][]string) {
	levels[level] = append(levels[level], t.Workspaces...)
	for _, sub := range t.Group {
		sub.collect(level, levels)
	}
	if t.Next != nil {
		t.Next.collect(level+1, levels)
	}
}

func (t *Target) format() []string {
	var result []string
	if len(t.Workspaces) > 0 {
		result = append(result, strings.Join(t.Workspaces, " "))
	}
	if t.Next != nil {
		result = append(result, t.Next.format()...)
	}
	return result
}

func (t *Target) clone() *Target {
	clone := &Target{
		Workspaces: append([]string{}, t.Workspaces...),
		Group:      make([]*Target, len(t.Group)),
	}
	for i, group := range t.Group {
		clone.Group[i] = group.clone()
	}
	if t.Next != nil {
		clone.Next = t.Next.clone()
	}
	return clone
}

func collapse(levels map[int][]string, level int) *Target {
	if workspaces, exists := levels[level]; exists {
		return &Target{
			Workspaces: workspaces,
			Next:       collapse(levels, level+1),
		}
	}
	return nil
}
