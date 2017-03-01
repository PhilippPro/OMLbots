# Main function to run the bot. This evaluates batch.size configurations. 
# Task, learner and the actual configuration are defined by the corresponding functions. 
# @param batch.size number of configurations to evaluate in parallel
# @param sample.learner.fun function to sample a learner from tunePair
# @param sample.task.fun sample a OML task
# @param sample.configuration given a lrn sample a configuration
# @param min.resources minimal resources to start benchmark (list with elements walltime and memory)
# @param max.resources maximum resources allowed for each evaluation (list with elements walltime and memory)
# @param lrn.ps.sets of available learners with matching parameter sets
# @param upload should the run be uploaded to OpenML
runBot = function(batch.size, sample.learner.fun = sampleRandomLearner, 
  sample.task.fun = sampleRandomTask, sample.configuration.fun = sampleRandomConfiguration, 
  min.resources = NULL, max.resources = NULL, lrn.ps.sets, upload = TRUE) {
  
  lrn = sample.learner.fun(lrn.ps.sets)
  print(sprintf("Selected learner: %s", lrn$lrn$short.name))
  task = sample.task.fun()
  print(sprintf("Selected OML task: %s", task))
  par = sample.configuration.fun(batch.size, lrn$ps)
  print("Selected configurations:")
  print(par)
  evalConfigurations(lrn$lrn, task, par, min.resources, max.resources, upload = upload)
}