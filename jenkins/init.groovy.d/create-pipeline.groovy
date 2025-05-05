import jenkins.model.*
import hudson.model.*
import javaposse.jobdsl.plugin.*
import org.jenkinsci.plugins.workflow.job.*

def instance = Jenkins.getInstance()

def jobName = "simple-java11-spring-app"
def job = instance.getItem(jobName)

if (job == null) {
    println("Создаем pipeline job '${jobName}'")

    def jenkins = Jenkins.instance
    def jobDef = new org.jenkinsci.plugins.workflow.job.WorkflowJob(jenkins, jobName)

    def scm = new hudson.plugins.git.GitSCM("https://github.com/Katapios/simple-java11-spring-app.git")
    scm.branches = [new hudson.plugins.git.BranchSpec("*/main")]
    def defn = new org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition(scm, "Jenkinsfile")
    defn.setLightweight(true)

    jobDef.setDefinition(defn)
    jenkins.reload()
    jenkins.add(jobDef, jobName)
    jobDef.save()
}
