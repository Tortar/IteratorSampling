var documenterSearchIndex = {"docs":
[{"location":"#API","page":"API","title":"API","text":"","category":"section"},{"location":"","page":"API","title":"API","text":"This is the API page of the package. For a general overview of the functionalities  consult the ReadMe.","category":"page"},{"location":"#General-functionalities","page":"API","title":"General functionalities","text":"","category":"section"},{"location":"","page":"API","title":"API","text":"ReservoirSample\nfit!\nempty!\nvalue\nordered_value\nnobs\nitsample","category":"page"},{"location":"#StreamSampling.ReservoirSample","page":"API","title":"StreamSampling.ReservoirSample","text":"ReservoirSample([rng], T, method = AlgRSWRSKIP())\nReservoirSample([rng], T, wfunc, method = AlgWRSWRSKIP())\nReservoirSample([rng], T, n::Int, method = AlgL(); ordered = false)\nReservoirSample([rng], T, wfunc, n::Int, method = AlgAExpJ(); ordered = false)\n\nInitializes a reservoir sample which can then be fitted with fit!. The first signature represents a sample where only a single element is collected. A weight function wfunc can be passed to apply weighted sampling. Look at the Algorithms section for the supported methods.\n\n\n\n\n\n","category":"function"},{"location":"#StatsAPI.fit!","page":"API","title":"StatsAPI.fit!","text":"fit!(rs::AbstractReservoirSample, el)\n\nUpdates the reservoir sample by taking into account the element passed.\n\n\n\n\n\n","category":"function"},{"location":"#Base.empty!","page":"API","title":"Base.empty!","text":"Base.empty!(rs::AbstractReservoirSample)\n\nResets the reservoir sample to its initial state.  Useful to avoid allocating a new sample in some cases.\n\n\n\n\n\n","category":"function"},{"location":"#OnlineStatsBase.value","page":"API","title":"OnlineStatsBase.value","text":"value(rs::AbstractReservoirSample)\n\nReturns the elements collected in the sample at the current  sampling stage.\n\nNote that even if the sampling respects the schema it is assigned when ReservoirSample is instantiated, some ordering in  the sample can be more probable than others. To represent each one  with the same probability call shuffle! over the result.\n\n\n\n\n\n","category":"function"},{"location":"#StreamSampling.ordered_value","page":"API","title":"StreamSampling.ordered_value","text":"ordered_value(rs::AbstractReservoirSample)\n\nReturns the elements collected in the sample at the current  sampling stage in the order they were collected. This applies only when ordered = true is passed in ReservoirSample.\n\n\n\n\n\n","category":"function"},{"location":"#StatsAPI.nobs","page":"API","title":"StatsAPI.nobs","text":"nobs(rs::AbstractReservoirSample)\n\nReturns the total number of elements that have been observed so far  during the sampling process.\n\n\n\n\n\n","category":"function"},{"location":"#StreamSampling.itsample","page":"API","title":"StreamSampling.itsample","text":"itsample([rng], iter, method = algL)\nitsample([rng], iter, weight, method = algAExpJ)\n\nReturn a random element of the iterator, optionally specifying a rng  (which defaults to Random.default_rng()) and a weight function which accept each element as input and outputs the corresponding weight. If the iterator is empty, it returns nothing.\n\n\n\nitsample([rng], iter, n::Int, method = algL; ordered = false)\nitsample([rng], iter, wv, n::Int, method = algAExpJ; ordered = false)\n\nReturn a vector of n random elements of the iterator,  optionally specifying a rng (which defaults to Random.default_rng()) and a method. ordered dictates whether an ordered sample (also called a sequential  sample, i.e. a sample where items appear in the same order as in iter) must be  collected.\n\nIf the iterator has less than n elements, in the case of sampling without replacement, it returns a vector of those elements.\n\n\n\n\n\n","category":"function"},{"location":"#Sampling-algorithms","page":"API","title":"Sampling algorithms","text":"","category":"section"},{"location":"","page":"API","title":"API","text":"StreamSampling.AlgR\nStreamSampling.AlgL\nStreamSampling.AlgRSWRSKIP\nStreamSampling.AlgARes\nStreamSampling.AlgAExpJ\nStreamSampling.AlgWRSWRSKIP","category":"page"},{"location":"#StreamSampling.AlgR","page":"API","title":"StreamSampling.AlgR","text":"Implements random sampling without replacement. \n\nAdapted from algorithm R described in \"Random sampling with a reservoir, J. S. Vitter, 1985\".\n\n\n\n\n\n","category":"type"},{"location":"#StreamSampling.AlgL","page":"API","title":"StreamSampling.AlgL","text":"Implements random sampling without replacement.\n\nAdapted from algorithm L described in \"Random sampling with a reservoir, J. S. Vitter, 1985\".\n\n\n\n\n\n","category":"type"},{"location":"#StreamSampling.AlgRSWRSKIP","page":"API","title":"StreamSampling.AlgRSWRSKIP","text":"Implements random sampling with replacement.\n\nAdapted fron algorithm RSWR_SKIP described in \"Reservoir-based Random Sampling with Replacement from  Data Stream, B. Park et al., 2008\".\n\n\n\n\n\n","category":"type"},{"location":"#StreamSampling.AlgARes","page":"API","title":"StreamSampling.AlgARes","text":"Implements weighted random sampling without replacement.\n\nAdapted from algorithm A-Res described in \"Weighted random sampling with a reservoir,  P. S. Efraimidis et al., 2006\".\n\n\n\n\n\n","category":"type"},{"location":"#StreamSampling.AlgAExpJ","page":"API","title":"StreamSampling.AlgAExpJ","text":"Implements weighted random sampling without replacement.\n\nAdapted from algorithm A-ExpJ described in \"Weighted random sampling with a reservoir,  P. S. Efraimidis et al., 2006\".\n\n\n\n\n\n","category":"type"},{"location":"#StreamSampling.AlgWRSWRSKIP","page":"API","title":"StreamSampling.AlgWRSWRSKIP","text":"Implements weighted random sampling with replacement.\n\nAdapted from algorithm WRSWR_SKIP described in \"A Skip-based Algorithm for Weighted Reservoir  Sampling with Replacement, A. Meligrana, 2024\". \n\n\n\n\n\n","category":"type"}]
}
