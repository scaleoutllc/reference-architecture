# terrallel
> maximize parallel execution of terraform

# What is this?
Terrallel is used to trace dependencies in an operator defined `Infrafile` of
terraform workspaces. Given a target workspace, terrallel outputs grouped sets
of dependent workspaces in a format optimized for parallel execution. Terrallel
is primarily designed for rapid creation and destruction of environments used
for testing.

## How does it work?
You define a YAML manifest describing workspaces. There are only four possible
keys.

`targets`: top level key. define named logical workspaces within.

Within targets, the following keys are allowed:

`workspaces`: list of paths to workspaces that do not depend on eachother.

`group`: list of target names that do not depend on eachother.

`next`: nest additional dependent `group` and `workspaces` entries under this.

There is one simple rule: `workspaces` and `group` cannot be sibling to
eachother. If you require both in a target, they must be separated by a
`next` key to nest them. This design decision enforces a configuration
format where the order of operation is explicit. If `workspace` and `group`
were allowed at the same level of nesting, terrallel would have to make an
implicit assumption about which takes precedence to properly produce the
dependency graph.

## Example
Here is a sample Infrafile:

```yaml
targets:
  numbers:
    group:
    - even
    - odd
    next:
      workspaces:
      - end-all

  odd:
    workspaces:
    - one
    - three
    - five
    next:
      workspaces:
      - end-odd
    
  even:
    workspaces:
    - two
    - four
    - six
    next:
      workspaces:
      - end-even
```

Running `terallel numbers` with the manifest above would produce the following:

```
one three five two four six
end-odd end-even
end-all
```

Each line of output is a space separated list of workspaces that can be applied
in parallel to produce the targeted workspace. Every subsequent line represents
all workspaces that depend on the ones above it.

Assuming the output was a list of paths to terraform workspaces, all workspaces
could be applied with maximum parallism thusly:

```bash
terallel numbers | while IFS= read -r path; do
  parallel --ungroup terraform -chdir={} init ::: ${path}
  parallel --ungroup terraform -chdir={} apply -auto-approve ::: ${path}
done
```

More complex manifests can be seen here: `internal/manifest/testdata`.

## Future Plans
A future version of terrallel may support defining the Infrafile using HCL. An
exploration of that configuration format resides in the testdata directory. 