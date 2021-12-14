// Copyright (c) 2021 Tigera, Inc. All rights reserved.

// Code generated by lister-gen. DO NOT EDIT.

package v3

import (
	"k8s.io/apimachinery/pkg/api/errors"
	"k8s.io/apimachinery/pkg/labels"
	"k8s.io/client-go/tools/cache"

	v3 "github.com/projectcalico/api/pkg/apis/projectcalico/v3"
)

// IPPoolLister helps list IPPools.
// All objects returned here must be treated as read-only.
type IPPoolLister interface {
	// List lists all IPPools in the indexer.
	// Objects returned here must be treated as read-only.
	List(selector labels.Selector) (ret []*v3.IPPool, err error)
	// Get retrieves the IPPool from the index for a given name.
	// Objects returned here must be treated as read-only.
	Get(name string) (*v3.IPPool, error)
	IPPoolListerExpansion
}

// iPPoolLister implements the IPPoolLister interface.
type iPPoolLister struct {
	indexer cache.Indexer
}

// NewIPPoolLister returns a new IPPoolLister.
func NewIPPoolLister(indexer cache.Indexer) IPPoolLister {
	return &iPPoolLister{indexer: indexer}
}

// List lists all IPPools in the indexer.
func (s *iPPoolLister) List(selector labels.Selector) (ret []*v3.IPPool, err error) {
	err = cache.ListAll(s.indexer, selector, func(m interface{}) {
		ret = append(ret, m.(*v3.IPPool))
	})
	return ret, err
}

// Get retrieves the IPPool from the index for a given name.
func (s *iPPoolLister) Get(name string) (*v3.IPPool, error) {
	obj, exists, err := s.indexer.GetByKey(name)
	if err != nil {
		return nil, err
	}
	if !exists {
		return nil, errors.NewNotFound(v3.Resource("ippool"), name)
	}
	return obj.(*v3.IPPool), nil
}
