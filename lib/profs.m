function profs = profs(info, manifest)
%
% profs - Profiler to measure models computational performance
%

if (manifest.analytical.MRC)
    profs.MRC.time = 0;
    for i=1:length(info)
        index = find(strcmp({info(i).FunctionTable.FunctionName}, 'MRC')==1);       
        profs.MRC.time = profs.MRC.time + info(i).FunctionTable(index).TotalTime;
    end
    profs.MRC.time = profs.MRC.time/length(info);
end

if (manifest.ML.NB)
    profs.NB.time = 0;
    for i=1:length(info)
        index = find(strcmp({info(i).FunctionTable.FunctionName}, 'NB')==1);
        profs.NB.time = profs.NB.time + info(i).FunctionTable(index).TotalTime;
    end
    profs.NB.time = profs.NB.time/length(info);
end

if (manifest.ML.LSVM)
    profs.LSVM.time = 0;
    for i=1:length(info)
        index = find(strcmp({info(i).FunctionTable.FunctionName}, 'LSVM')==1);
        profs.LSVM.time = profs.LSVM.time + info(i).FunctionTable(index).TotalTime;
    end
    profs.LSVM.time = profs.LSVM.time/length(info);
end

if (manifest.ML.GSVM)
    profs.GSVM.time = 0;
    for i=1:length(info)
        index = find(strcmp({info(i).FunctionTable.FunctionName}, 'GSVM')==1);
        profs.GSVM.time = profs.GSVM.time + info(i).FunctionTable(index).TotalTime;
    end
    profs.GSVM.time = profs.GSVM.time/length(info);
end

if (manifest.ML.MLP)
    profs.MLP.time = 0;
    for i=1:length(info)
        index = find(strcmp({info(i).FunctionTable.FunctionName}, 'MLP')==1);
        profs.MLP.time = profs.MLP.time + info(i).FunctionTable(index).TotalTime;
    end
    profs.MLP.time = profs.MLP.time/length(info);
end


