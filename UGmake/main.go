package main

import (
	"fmt"
	"os"
	"os/exec"
)

func main() {
	fmt.Println("Davinci GMake")

	args := os.Args[1:]
	if len(args) >= 1 && args[0] == "--init" {
		dir := "."
		if len(args) > 1 {
			dir = args[1]
		}
		cmd := exec.Command("ruby", "resolve_deps.rb", "--init", dir)
		output, err := cmd.CombinedOutput()
		if err != nil {
			fmt.Println("Ruby init error:", err)
		} else {
			fmt.Println(string(output))
		}
		return
	}

	content, err := os.ReadFile("GMake")
	if err != nil {
		fmt.Println("Error reading GMake file:", err)
		return
	}

	parseGMake(string(content))

	// Use task name from command line, default to "build"
	taskName := "build"
	if len(args) >= 1 {
		taskName = args[0]
	}

	// Only call Ruby if dependencies exist
	if deps, ok := taskDeps[taskName]; ok && len(deps) > 0 {
		fmt.Println("Calling Ruby to resolve dependencies...")
		orderedTasks := resolveDepsWithRuby(taskName)
		fmt.Println("Resolved task order:", orderedTasks)
		for _, t := range orderedTasks {
			runTask(t)
		}
	} else {
		runTask(taskName)
	}
}
