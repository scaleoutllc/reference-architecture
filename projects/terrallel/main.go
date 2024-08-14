package main

import (
	"flag"
	"fmt"
	"log/slog"
	"os"
	"terrallel/internal/manifest"
)

func main() {
	file := flag.String("f", "Infrafile", "Path to the infrastructure manifest (default: Infrafile)")
	flag.Parse()
	args := flag.Args()
	if len(args) != 1 {
		fmt.Printf("Usage: %s [-fr] <name>", os.Args[0])
		os.Exit(1)
	}
	infra, err := manifest.New(*file, os.Stdout, slog.LevelInfo)
	if err != nil {
		fmt.Print(err)
		os.Exit(1)
	}
	target, err := infra.Target(args[0])
	if err != nil {
		fmt.Print(err)
		os.Exit(1)
	}
	//fmt.Print(target.Collapse())
	fmt.Printf("%s\n", target.Render())
}
