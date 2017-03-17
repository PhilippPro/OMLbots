library(devtools)
load_all()

overview = getMlrRandomBotOverview("botV1")
print(overview)

tbl.results = getMlrRandomBotResults("botV1")
print(tbl.results)

tbl.hypPars = getMlrRandomBotHyperpars("botV1")
print(tbl.hypPars)

task.data = makeBotTable(measure.name = "area.under.roc.curve", learner.name = "mlr.classif.glmnet", 
  tbl.results = tbl.results, tbl.hypPars = tbl.hypPars, tbl.metaFeatures = NULL)

task.ids = unique(tbl.results$task.id)
surr = makeSurrogateModel(measure.name = "area.under.roc.curve", learner.name = "mlr.classif.glmnet", 
  task.id = task.ids, tbl.results = tbl.results, tbl.hypPars = tbl.hypPars, param.set = lrn.par.set$classif.glmnet.set$param.set)

rnd.points = generateRandomDesign(1000, lrn.par.set$classif.glmnet.set$param.set)
preds = matrix(NA, nrow(rnd.points), length(surr))
for(i in seq_along(surr)) {
  preds[, i] = predict(surr[[i]], newdata = rnd.points)$data$response
}

# Best default
average_preds = apply(preds, 1, mean)
average_preds[average_preds == max(average_preds)]
rnd.points[average_preds == max(average_preds), ]





# Anhang
library(devtools)
load_all()

sampleRandomLearner1 = function(lrn.ps.sets) {
  sample(lrn.ps.sets[5], size = 1)[[1]]
}

unlink("test", recursive = TRUE)
runBot(batch.size = 10, 
  sample.learner.fun = sampleRandomLearner1,  
  sample.task.fun = sampleSimpleTask, # replace with sampleRandomTask
  sample.configuration.fun = sampleRandomConfiguration, 
  lrn.ps.sets = lrn.par.set,
  path = "test"
)

# rpart ok, glmnet ok, svm ok, ranger: mtry Problematik -> gelöst, kknn ok, xgboost: numeric Problematik -> gelöst

regis = loadRegistry("test")
getStatus()
res_classif_load = reduceResultsList(ids = findDone(), fun = function(r) as.list(r), reg = regis)
res_classif_load[[1]]$bmr
getErrorMessages()

regis = loadRegistry("reference")
getStatus()
res_classif_load = reduceResultsList(ids = findDone(), fun = function(r) as.list(r), reg = regis)
getErrorMessages()

