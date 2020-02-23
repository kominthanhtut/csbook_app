pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh 'docker run --rm -v ${WORKSPACE}/${JOB_NAME}_${BRANCH_NAME}:/build --workdir /build cirrusci/flutter:stable flutter build apk --release'
      }
    }

  }
}