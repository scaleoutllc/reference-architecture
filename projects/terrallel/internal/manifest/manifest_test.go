package manifest

import (
	"log/slog"
	"os"
	"testing"

	"github.com/google/go-cmp/cmp"
	"gopkg.in/yaml.v3"
)

func TestNew(t *testing.T) {
	m, err := New("testdata/test.yml", os.Stdout, slog.LevelInfo)
	if err != nil {
		t.Errorf("failed to load: %s", err)
	}
	expectedBytes, err := os.ReadFile("testdata/test.resolved.yml")
	if err != nil {
		t.Errorf("failed to load resolved manifest")
	}
	var expected map[string]interface{}
	if err := yaml.Unmarshal(expectedBytes, &expected); err != nil {
		t.Error("failed to unmarshal expected bytes")
	}
	var actual map[string]interface{}
	if err := yaml.Unmarshal(m.Bytes(), &actual); err != nil {
		t.Error("failed to unmarshal expected bytes")
	}
	if diff := cmp.Diff(expected, actual); diff != "" {
		t.Errorf("YAML files differ (-file1 +file2):\n%s", diff)
	}
}

func TestNewInfrafile(t *testing.T) {
	m, err := New("testdata/infra.yml", os.Stdout, slog.LevelInfo)
	if err != nil {
		t.Errorf("failed to load: %s", err)
	}
	expectedBytes, err := os.ReadFile("testdata/infra.resolved.yml")
	if err != nil {
		t.Errorf("failed to load resolved manifest")
	}
	var expected map[string]interface{}
	if err := yaml.Unmarshal(expectedBytes, &expected); err != nil {
		t.Error("failed to unmarshal expected bytes")
	}
	var actual map[string]interface{}
	if err := yaml.Unmarshal(m.Bytes(), &actual); err != nil {
		t.Error("failed to unmarshal expected bytes")
	}
	if diff := cmp.Diff(expected, actual); diff != "" {
		t.Errorf("YAML files differ (-file1 +file2):\n%s", diff)
	}
}
