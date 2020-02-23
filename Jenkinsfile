pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh ''' flutter build apk --target-platform android-arm,android-arm64 --split-per-abi
'''
      }
    }

    stage('Archive') {
      steps {
        archiveArtifacts 'build/app/outputs/apk/release/*.apk'
      }
    }

    stage('Publish') {
      steps {
        telegramUploader(chatId: 'hkfuertes', filter: '${WORKSPACE}/build/app/outputs/apk/release/*.apk')
      }
    }

  }
}