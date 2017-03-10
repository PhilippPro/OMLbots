# To-Do: Add a tag for these learners
reference1.lrn.par.set = makeLrnPsSets(learner = makeLearner("classif.randomForest", predict.type = "prob"), 
  param.set = makeParamSet(
    makeIntegerParam("ntree", lower = 2000, upper = 2000, default = 2000)
    )
)

reference2.lrn.par.set = makeLrnPsSets(learner = makeLearner("classif.featureless", predict.type = "prob"), 
  param.set = makeParamSet(
    makeDiscreteParam("method", values = "majority", default = "majority")
  )
)

tasks = listOMLTasks(number.of.classes = 2L, number.of.instances = c(100L, 500L), 
  number.of.features = c(3L, 20L), number.of.missing.values = 0, estimation.procedure = "33% Holdout set")

for (i in seq_along(tasks)) {
  fixed.task = function() list(id = tasks$task.id[1], name = tasks$name[1])
  
  runBot(10 , sample.learner.fun = sampleRandomLearner, 
    sample.task.fun = fixed.task, sample.configuration.fun = sampleRandomConfiguration, 
    lrn.ps.sets = reference1.lrn.par.set, upload = TRUE,
    path = "reference")
  
  runBot(10 , sample.learner.fun = sampleRandomLearner, 
    sample.task.fun = fixed.task, sample.configuration.fun = sampleRandomConfiguration, 
    lrn.ps.sets = reference2.lrn.par.set, upload = TRUE,
    path = "reference")
}