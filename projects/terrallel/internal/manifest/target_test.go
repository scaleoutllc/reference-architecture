package manifest

import (
	"log/slog"
	"os"
	"strings"
	"testing"

	"github.com/google/go-cmp/cmp"
)

func TestTargetRender(t *testing.T) {
	m, err := New("testdata/test.yml", os.Stdout, slog.LevelInfo)
	if err != nil {
		t.Errorf("failed to load: %s", err)
	}
	tests := map[string][]string{
		"noDepsOne": {
			"foo bar",
		},
		"noDepsTwo": {
			"foo-parallel bar-parallel",
		},
		"onlyGroup": {
			"foo bar",
		},
		"doubleIndirectGroup": {
			"foo bar",
		},
		"groupAndNestedWorkspace": {
			"foo bar foo-parallel bar-parallel",
			"baz qux",
		},
		"nestedEverything": {
			"first",
			"foo bar foo-parallel bar-parallel",
			"almost-last",
			"last",
		},
		"workspacesThenGroup": {
			"first second",
			"foo bar foo-parallel bar-parallel",
			"last",
		},
		"finalBoss": {
			"first second",
			"foo bar foo-parallel bar-parallel",
			"last",
			"finito",
		},
	}
	for name, expected := range tests {
		t.Run(name, func(t *testing.T) {
			target, err := m.Target(name)
			if err != nil {
				t.Error(err)
			}
			actual := target.Render()
			expected := strings.Join(expected, "\n")
			if diff := cmp.Diff(expected, actual); diff != "" {
				t.Errorf("%s mismatch:\n---\n%s\n---\n%s\n---\n%s", name, actual, expected, diff)
			}
		})
	}
}

func TestTargetInfra(t *testing.T) {
	m, err := New("testdata/infra.yml", os.Stdout, slog.LevelInfo)
	if err != nil {
		t.Errorf("failed to load: %s", err)
	}
	tests := map[string][]string{
		"fast-dev": {
			"shared/dev/aws/us-east-1/network fast/dev/aws/us-east-1/network shared/dev/aws/ap-southeast-2/network fast/dev/aws/ap-southeast-2/network shared/dev/gcp/global/network fast/dev/gcp/global/network",
			"shared/dev/aws/global/routing shared/dev/gcp/us-east1/network fast/dev/gcp/us-east1/network shared/dev/gcp/australia-southeast1/network fast/dev/gcp/australia-southeast1/network",
			"shared/dev/gcp/global/routing fast/dev/gcp/us-east1/cluster fast/dev/gcp/australia-southeast1/cluster fast/dev/aws/global/accelerator",
			"shared/dev/multi-cloud/routing fast/dev/gcp/us-east1/namespaces/autoneg-system fast/dev/gcp/us-east1/namespaces/kube-system fast/dev/gcp/us-east1/namespaces/istio-system fast/dev/gcp/australia-southeast1/namespaces/autoneg-system fast/dev/gcp/australia-southeast1/namespaces/kube-system fast/dev/gcp/australia-southeast1/namespaces/istio-system fast/dev/gcp/global/load-balancer fast/dev/aws/us-east-1/cluster fast/dev/aws/ap-southeast-2/cluster",
			"fast/dev/gcp/us-east1/namespaces/ingress fast/dev/gcp/australia-southeast1/namespaces/ingress fast/dev/aws/us-east-1/namespaces/kube-system fast/dev/aws/ap-southeast-2/namespaces/kube-system",
			"fast/dev/aws/us-east-1/namespaces/istio-system fast/dev/aws/ap-southeast-2/namespaces/istio-system",
			"fast/dev/aws/us-east-1/namespaces/ingress fast/dev/aws/ap-southeast-2/namespaces/ingress",
		},
		"network-dev-mesh": {
			"shared/dev/aws/us-east-1/network fast/dev/aws/us-east-1/network shared/dev/aws/ap-southeast-2/network fast/dev/aws/ap-southeast-2/network shared/dev/gcp/global/network fast/dev/gcp/global/network",
			"shared/dev/aws/global/routing shared/dev/gcp/us-east1/network fast/dev/gcp/us-east1/network shared/dev/gcp/australia-southeast1/network fast/dev/gcp/australia-southeast1/network",
			"shared/dev/gcp/global/routing",
			"shared/dev/multi-cloud/routing",
		},
		"network-dev-aws": {
			"shared/dev/aws/us-east-1/network fast/dev/aws/us-east-1/network shared/dev/aws/ap-southeast-2/network fast/dev/aws/ap-southeast-2/network",
			"shared/dev/aws/global/routing",
		},
		"network-dev-aws-us": {
			"shared/dev/aws/us-east-1/network fast/dev/aws/us-east-1/network",
		},
		"network-dev-aws-au": {
			"shared/dev/aws/ap-southeast-2/network fast/dev/aws/ap-southeast-2/network",
		},
		"network-dev-gcp": {
			"shared/dev/gcp/global/network fast/dev/gcp/global/network",
			"shared/dev/gcp/us-east1/network fast/dev/gcp/us-east1/network shared/dev/gcp/australia-southeast1/network fast/dev/gcp/australia-southeast1/network",
			"shared/dev/gcp/global/routing",
		},
		"network-dev-gcp-us": {
			"shared/dev/gcp/us-east1/network fast/dev/gcp/us-east1/network",
		},
		"network-dev-gcp-au": {
			"shared/dev/gcp/australia-southeast1/network fast/dev/gcp/australia-southeast1/network",
		},
		"fast-dev-cluster-mesh": {
			"fast/dev/gcp/us-east1/cluster fast/dev/gcp/australia-southeast1/cluster fast/dev/aws/global/accelerator",
			"fast/dev/gcp/us-east1/namespaces/autoneg-system fast/dev/gcp/us-east1/namespaces/kube-system fast/dev/gcp/us-east1/namespaces/istio-system fast/dev/gcp/australia-southeast1/namespaces/autoneg-system fast/dev/gcp/australia-southeast1/namespaces/kube-system fast/dev/gcp/australia-southeast1/namespaces/istio-system fast/dev/aws/us-east-1/cluster fast/dev/aws/ap-southeast-2/cluster",
			"fast/dev/gcp/us-east1/namespaces/ingress fast/dev/gcp/australia-southeast1/namespaces/ingress fast/dev/aws/us-east-1/namespaces/kube-system fast/dev/aws/ap-southeast-2/namespaces/kube-system",
			"fast/dev/gcp/global/load-balancer fast/dev/aws/us-east-1/namespaces/istio-system fast/dev/aws/ap-southeast-2/namespaces/istio-system",
			"fast/dev/aws/us-east-1/namespaces/ingress fast/dev/aws/ap-southeast-2/namespaces/ingress",
		},
		"fast-dev-gcp-clusters": {
			"fast/dev/gcp/us-east1/cluster fast/dev/gcp/australia-southeast1/cluster",
			"fast/dev/gcp/us-east1/namespaces/autoneg-system fast/dev/gcp/us-east1/namespaces/kube-system fast/dev/gcp/us-east1/namespaces/istio-system fast/dev/gcp/australia-southeast1/namespaces/autoneg-system fast/dev/gcp/australia-southeast1/namespaces/kube-system fast/dev/gcp/australia-southeast1/namespaces/istio-system",
			"fast/dev/gcp/us-east1/namespaces/ingress fast/dev/gcp/australia-southeast1/namespaces/ingress",
			"fast/dev/gcp/global/load-balancer",
		},
		"fast-dev-gcp-us-cluster": {
			"fast/dev/gcp/us-east1/cluster",
			"fast/dev/gcp/us-east1/namespaces/autoneg-system fast/dev/gcp/us-east1/namespaces/kube-system fast/dev/gcp/us-east1/namespaces/istio-system",
			"fast/dev/gcp/us-east1/namespaces/ingress",
		},
		"fast-dev-gcp-au-cluster": {
			"fast/dev/gcp/australia-southeast1/cluster",
			"fast/dev/gcp/australia-southeast1/namespaces/autoneg-system fast/dev/gcp/australia-southeast1/namespaces/kube-system fast/dev/gcp/australia-southeast1/namespaces/istio-system",
			"fast/dev/gcp/australia-southeast1/namespaces/ingress",
		},
		"fast-dev-aws-clusters": {
			"fast/dev/aws/global/accelerator",
			"fast/dev/aws/us-east-1/cluster fast/dev/aws/ap-southeast-2/cluster",
			"fast/dev/aws/us-east-1/namespaces/kube-system fast/dev/aws/ap-southeast-2/namespaces/kube-system",
			"fast/dev/aws/us-east-1/namespaces/istio-system fast/dev/aws/ap-southeast-2/namespaces/istio-system",
			"fast/dev/aws/us-east-1/namespaces/ingress fast/dev/aws/ap-southeast-2/namespaces/ingress",
		},
		"fast-dev-aws-us-cluster": {
			"fast/dev/aws/us-east-1/cluster",
			"fast/dev/aws/us-east-1/namespaces/kube-system",
			"fast/dev/aws/us-east-1/namespaces/istio-system",
			"fast/dev/aws/us-east-1/namespaces/ingress",
		},
		"fast-dev-aws-au-cluster": {
			"fast/dev/aws/ap-southeast-2/cluster",
			"fast/dev/aws/ap-southeast-2/namespaces/kube-system",
			"fast/dev/aws/ap-southeast-2/namespaces/istio-system",
			"fast/dev/aws/ap-southeast-2/namespaces/ingress",
		},
	}
	for name, expected := range tests {
		t.Run(name, func(t *testing.T) {
			target, err := m.Target(name)
			if err != nil {
				t.Error(err)
			}
			actual := target.Render()
			expected := strings.Join(expected, "\n")
			if diff := cmp.Diff(expected, actual); diff != "" {
				//t.Errorf("%s\n---\n%s", target, target.clone().collapse())
				t.Errorf("actual:\n%s\n\nexpected:\n%s", actual, expected)
			}
		})
	}
}
