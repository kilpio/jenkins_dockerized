#!groovy

import jenkins.model.*
import java.util.logging.Logger

def logger = Logger.getLogger("")
def installed = false
def initialized = false

def pluginParameter = "\
checks-api \
pipeline-build-step \
matrix-auth \
pipeline-rest-api \
pipeline-stage-view \
github-branch-source \
ssh \
ant \
workflow-step-api \
build-user-vars-plugin \
groovy-postbuild \
github \
lockable-resources \
ssh-credentials \
workflow-durable-task-step \
build-timeout \
credentials \
git \
git-server \
ace-editor \
groovy \
pipeline-input-step \
structs \
echarts-api \
email-ext \
configuration-as-code-groovy \
credentials-binding \
ws-cleanup \
workflow-cps-global-lib \
configuration-as-code \
branch-api \
ldap \
pipeline-stage-tags-metadata \
mask-passwords \
plugin-util-api \
pipeline-milestone-step \
junit \
pipeline-model-api \
jsch \
resource-disposer \
workflow-job \
authorize-project \
pipeline-model-definition \
workflow-cps \
display-url-api \
workflow-api \
pipeline-graph-analysis \
workflow-basic-steps \
durable-task \
handlebars \
scm-api \
trilead-api \
ssh-steps \
docker-workflow \
jquery-detached \
cloudbees-folder \
workflow-multibranch \
okhttp-api \
workflow-aggregator \
apache-httpcomponents-client-4-api \
pipeline-stage-step \
ssh-slaves \
gradle \
command-launcher \
badge \
role-strategy \
workflow-scm-step \
mailer \
authentication-tokens \
matrix-project \
antisamy-markup-formatter \
jquery3-api \
snakeyaml-api \
workflow-support \
docker-commons \
pipeline-github-lib \
plain-credentials \
jdk-tool \
jackson2-api \
bootstrap4-api \
token-macro \
momentjs \
ssh-agent \
pipeline-model-extensions \
script-security \
timestamper \
git-client \
github-api \
bouncycastle-api \
pam-auth \
ansicolor \
popper-api \
font-awesome-api \
thinBackup \
"

def plugins = pluginParameter.split()
logger.info("" + plugins)
def instance = Jenkins.getInstance()
def pm = instance.getPluginManager()
def uc = instance.getUpdateCenter()
plugins.each {
  logger.info("Checking " + it)
  if (!pm.getPlugin(it)) {
    logger.info("Looking UpdateCenter for " + it)
    if (!initialized) {
      uc.updateAllSites()
      initialized = true
    }
    def plugin = uc.getPlugin(it)
    if (plugin) {
      logger.info("Installing " + it)
        def installFuture = plugin.deploy()
      while(!installFuture.isDone()) {
        logger.info("Waiting for plugin install: " + it)
        sleep(3000)
      }
      installed = true
    }
  }
}
if (installed) {
  instance.save()
  instance.restart()
}
