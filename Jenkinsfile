pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh 'docker run -v ${WORKSPACE}:/build --workdir /build cirrusci/flutter:stable flutter build apk --release'
      }
    }

  }
}