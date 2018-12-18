def jenkinsfile
node {
    checkout([
        $class: 'GitSCM',
        poll: false,
        branches: [[name: 'master']],
        userRemoteConfigs: [[url: 'https://github.com/scaleway/image-tools.git']]
    ])
    jenkinsfile = load 'jenkins/image.groovy'
}

jenkinsfile()
