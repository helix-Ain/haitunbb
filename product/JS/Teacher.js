app.factory('initService', function() {
	return {
		initReady: function($scope, ci_objEvent) {
			$scope.title = ['health-title'];
			ci_objEvent();
		},
	}
});
