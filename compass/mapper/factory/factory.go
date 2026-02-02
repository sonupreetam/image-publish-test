package factory

import (
	"github.com/sonupreetam/image-publish-test/compass/mapper"
	"github.com/sonupreetam/image-publish-test/compass/mapper/plugins/basic"
)

func MapperByID(_ mapper.ID) mapper.Mapper {
	return basic.NewBasicMapper()
}
