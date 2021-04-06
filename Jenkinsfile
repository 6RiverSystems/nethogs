#!/usr/bin/env groovy


parallel(
    failFast: true,
    "amd64-debian": {
        node('docker && amd64') {
          try {
            stage("amd64 build ros_comm"){
                checkout scm
                docker.image('debian:stretch').inside("-u 0:0 -v ${env.WORKSPACE}:/workspace/src") {
                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'artifactory_apt',
                        usernameVariable: 'ARTIFACTORY_USERNAME', passwordVariable: 'ARTIFACTORY_PASSWORD']]) {
                    withCredentials([string(credentialsId: 'github-access-token', variable: 'GITHUB_TOKEN')]) {
                        sh '''
                        export ARCH='amd64'
                        export DISTRO='xenial'
                        ./build.sh
                        '''
                    } }
                }
            }
            } catch (e) {
              echo 'This will run only if failed'
              // Since we're catching the exception in order to report on it,
              // we need to re-throw it, to ensure that the build is marked as failed
              throw e
            } finally {
              echo "Running arm64 finally statement"
              stage("Cleanup") {
                echo "Inside cleanup stage"
                docker.image('debian:stretch').inside('-u 0:0') {
                  sh "chmod -R 777 ."
                }
              }
            }
        }},

    "arm64-debian": {
        node('docker && arm64') {
          try {
                stage("arm64 build ros_comm"){
                    checkout scm
                    docker.image('arm64v8/debian:stretch').inside("-u 0:0 -v ${env.WORKSPACE}:/workspace/src") {
                        withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'artifactory_apt',
                                          usernameVariable: 'ARTIFACTORY_USERNAME', passwordVariable: 'ARTIFACTORY_PASSWORD']]) {
                            withCredentials([string(credentialsId: 'github-access-token', variable: 'GITHUB_TOKEN')]) {
                                sh '''
                                   export ARCH='arm64'
                                   export DISTRO='xenial'
                                   ./build.sh
                                   '''
                            }
                            withCredentials([string(credentialsId: 'github-access-token', variable: 'GITHUB_TOKEN')]) {
                                sh '''
                                   export ARCH='arm64'
                                   export DISTRO='bionic'
                                   ./build.sh
                                   '''
                            }
                        }
                    }
                }
          } catch (e) {
            echo 'This will run only if failed'
            // Since we're catching the exception in order to report on it,
            // we need to re-throw it, to ensure that the build is marked as failed
            throw e
          } finally {
            echo "Running arm64 finally statement"
            stage("Cleanup") {
              echo "Inside cleanup stage"
              docker.image('arm64v8/debian:stretch').inside('-u 0:0') {
                sh "chmod -R 777 ."
              }
            }
          }
        }}
)
