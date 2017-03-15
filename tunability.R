library(devtools)
load_all()

sampleRandomLearner1 = function(lrn.ps.sets) {
  sample(lrn.ps.sets[4], size = 1)[[1]]
}

unlink("test", recursive = TRUE)
runBot(batch.size = 10, 
  sample.learner.fun = sampleRandomLearner1,  
  sample.task.fun = sampleSimpleTask, # replace with sampleRandomTask
  sample.configuration.fun = sampleRandomConfiguration, 
  lrn.ps.sets = lrn.par.set,
  path = "test"
)

# rpart ok, glmnet ok, svm ok, ranger: mtry Problematik -> gelöst, kknn -> wrong package name, xgboost: numeric Problematik -> gelöst

regis = loadRegistry("test")
getStatus()
res_classif_load = reduceResultsList(ids = findDone(), fun = function(r) as.list(r), reg = regis)

res_classif_load[[1]]$bmr

getErrorMessages()








library(devtools)
load_all()

overview = getMlrRandomBotOverview("botV1")
print(overview)

tbl.results = getMlrRandomBotResults("botV1")
print(tbl.results)

tbl.hypPars = getMlrRandomBotHyperpars("botV1")
print(tbl.hypPars)

