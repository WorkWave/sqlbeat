package main

import (
	"os"

	"github.com/elastic/beats/v7/libbeat/cmd"
	"github.com/elastic/beats/v7/libbeat/cmd/instance"

	"github.com/workwave/sqlbeat/beater"
)

var RootCmd = cmd.GenRootCmdWithSettings(beater.New, instance.Settings{Name: "sqlbeat"})

func main() {
	if err := RootCmd.Execute(); err != nil {
		os.Exit(1)
	}
}
