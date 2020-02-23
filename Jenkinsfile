pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh ''' flutter build apk --target-platform android-arm,android-arm64 --split-per-abi
'''
      }
    }

  }
}