angular.module('helloWorldApp')
.controller('HomeController', [
    '$scope',
    function($scope) {
        console.log('Loading Home view');
        $scope.message = '🅰ngularJS with Gulp 🥤 say Hello World!';
    }
])