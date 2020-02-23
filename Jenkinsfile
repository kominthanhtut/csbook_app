pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh 'docker run --rm -it -v ${PWD}:/build --workdir /build cirrusci/flutter:stable flutter build --release'
      }
    }

  }
}