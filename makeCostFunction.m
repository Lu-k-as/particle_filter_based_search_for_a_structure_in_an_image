function f = makeCostFunction(pcashape,predscorecont,costfunct)
    f = @costFunction;
    function c = costFunction(params)
        c = costfunct(pcashape,predscorecont,[round(params(1),2),round(params(2),2),round(params(3),2),round(params(4),2)]);
    end
end