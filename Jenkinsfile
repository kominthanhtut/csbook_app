pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh ''' docker run --rm --volumes-from jenkins-docker --workdir ${WORKSPACE} cirrusci/flutter:stable flutter build apk --target-platform android-arm,android-arm64 --split-per-abi
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
        telegramUploader(chatId: '-1001492622304', filter: 'build/app/outputs/apk/release/*.apk', caption: 'Build: ${BUILD_TAG}')
      }
    }

  }
}