package cli

import (
	"os"

	pnt "github.com/kiracore/tools/ipfs-api/pkg/pinatav1"
	"github.com/spf13/cobra"
)

var testCommand = &cobra.Command{
	Use:   "test",
	Short: "Testing connection to pinata.cloud",
	Long:  "Testing connection and given key",
	RunE:  test,
}

func test(cmd *cobra.Command, args []string) error {
	keys, _ := grabKey(key)
	if err := pnt.Test(keys); err != nil {
		os.Exit(1)
		return err
	}
	return nil
}
