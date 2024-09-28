
using PrecompileTools

@setup_workload let
    iter = Iterators.filter(x -> x != 10, 1:20);
    wv(el) = 1.0
    update_s!(rs, iter) = for x in iter fit!(rs, x) end
    @compile_workload let
        rs = ReservoirSample(Int, AlgR())
        update_s!(rs, iter)
        rs = ReservoirSample(Int, wv, AlgAExpJ())
        update_s!(rs, iter)
        rs = ReservoirSample(Int, 2, AlgR())
        update_s!(rs, iter)
        rs = ReservoirSample(Int, 2, AlgL())
        update_s!(rs, iter)
        rs = ReservoirSample(Int, 2, AlgRSWRSKIP())
        update_s!(rs, iter)
        rs = ReservoirSample(Int, wv, 2, AlgARes())
        update_s!(rs, iter)
        rs = ReservoirSample(Int, wv, 2, AlgAExpJ())
        update_s!(rs, iter)
        rs = ReservoirSample(Int, wv, 2, AlgWRSWRSKIP())
        update_s!(rs, iter)
    end
end
