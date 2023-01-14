package cli

import (
	"errors"

	log "github.com/kiracore/tools/ipfs-api/pkg/ipfslog"
	pnt "github.com/kiracore/tools/ipfs-api/pkg/pinatav2"

	"github.com/spf13/cobra"
)

var pinnedCommand = &cobra.Command{
	Use:   "pinned <CID-v0/v1/file-path/file-name/folder-name>",
	Short: "File/Folder check allowing to test if the file/folder is already pinned on IPFS or not",
	Long:  "File/Folder check allowing to test if the file/folder is already pinned on IPFS or not",
	Args:  cobra.MaximumNArgs(1),
	RunE:  pinned,
}

func pinned(cmd *cobra.Command, args []string) error {
	if len(args) == 0 {
		log.Error("pinned: empty arg")
		return errors.New("args can't be empty")
	}
	keys, err := pnt.GrabKey(key)
	if err != nil {
		return err
	}

	p := pnt.PinataApi{}
	p.SetKeys(keys)
	if err := p.Pinned(args[0]); err != nil {
		log.Error("Cant't pin this")
		return err
	}
	err = p.OutputPinnedJson()
	if err != nil {
		return err
	}

	return nil
}