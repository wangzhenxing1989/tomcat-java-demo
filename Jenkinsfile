podTemplate(label: 'jnlp-slave', cloud: 'kubernetes', containers: [
    containerTemplate(
        name: 'jnlp', 
        image: '192.168.9.85/library/jenkins-slave', 
        alwaysPullImage: true 
    ),
  ],
  volumes: [
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'),
    hostPathVolume(mountPath: '/usr/bin/docker', hostPath: '/usr/bin/docker'),
  ],
  imagePullSecrets: ['registry-pull-secret'],
) 
{
  node("jnlp-slave"){
      stage('Git Checkout'){
         checkout([$class: 'GitSCM', branches: [[name: '${Tag}']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'fbb3cdad-8580-402c-988a-07323931b2eb', url: 'git@192.168.9.85:/home/git/java-demo']]])
      }
      stage('Unit Testing'){
      	echo "Unit Testing..."
      }
      stage('Maven Build'){
          sh "mvn clean package -Dmaven.test.skip=true"
      }
      stage('Build and Push Image'){
          sh '''
          Registry=192.168.9.85
          docker login -u admin -p Harbor12345 $Registry 
          docker build -t $Registry/project/demo:${Tag} -f Dockerfile .
          docker push $Registry/project/demo:${Tag}
          '''
      }
      stage('Deploy to K8S'){
          sh '''
          sed -i "/demo/{s/latest/${Tag}/}" deploy.yaml
          sed -i "/namespace/{s/default/${Namespace}/}" deploy.yaml
          ''' 
          kubernetesDeploy configs: 'deploy.yaml', kubeConfig: [path: ''], kubeconfigId: 'b88ff15c-ce88-4944-a852-88af267f50e8', secretName: '', ssh: [sshCredentialsId: '*', sshServer: ''], textCredentials: [certificateAuthorityData: '', clientCertificateData: '', clientKeyData: '', serverUrl: 'https://']
      }
      stage('Testing'){
          echo "Testing..."
      }
  }
}
