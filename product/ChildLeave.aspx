<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ChildLeave.aspx.cs" Inherits="Digicloud.DAM.Web.CI.Mobile.ChildLeave" %>

<!DOCTYPE html>
<html ng-app='app'>

	<head>
		<title>宝宝366</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<meta name="viewport" content="initial-scale=1, maximum-scale=1, user-scalable=no, width=device-width">
		<link rel='stylesheet' href='CSS/Ionic/ionic.min.css' />
		<script src="JS/Ionic/ionic.bundle.min.js"></script>
		<script src="JS/chart.min.js"></script>
		<script src="JS/Constants.js"></script>
		<script src="JS/Common.min.js?v=1.0"></script>
		<script src="JS/Teacher.js?v=1.0"></script>
		<style>
			span.th,
			span.td {
				width: 33%;
				display: inline-block;
				text-align: center;
				font-size: 14px;
				color: #828282;
			}
			
			.item {
				padding: 12px;
			}
		</style>
	</head>

	<body ng-controller='app' ng-init='init()' ng-cloak>
		<ion-header-bar class='bar-calm' style='background-color: #009BE8;background-image:url(Image/teacher_title.png);background-size:cover;'>
			<button class='button button-icon icon ion-ios-arrow-left' onclick="back()">返回</button>
			<h1 class='title'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;幼儿请假</h1>
		</ion-header-bar>
		<ion-content class='has-header' style='background-color: #E2EEF6;'>
			<ion-list>
				<label class="item item-input item-select" style='height:45px;'>
				    <select style='right:25%;' ng-change='change(time)' ng-model='time'>
				      <option>2016年4月5日</option>
				      <option>2016年4月4日</option>
				      <option>2016年4月3日</option>
				    </select>
				</label>
				<ion-item><span class='th'>班级</span><span class='th'>病假人数</span><span class='th'>事假人数</span></ion-item>
				<ion-item><span class='td'>大三班</span><span class='td'>1</span><span class='td'>3</span></ion-item>
				<ion-item><span class='td'>大二班</span><span class='td'>2</span><span class='td'>5</span></ion-item>
				<ion-item><span class='td'>中二班</span><span class='td'>0</span><span class='td'>8</span></ion-item>
				<ion-item><span class='td'>大三班</span><span class='td'>3</span><span class='td'>4</span></ion-item>
				<ion-item><span class='td'>大三班</span><span class='td'>0</span><span class='td'>0</span></ion-item>
				<ion-item><span class='td'>小三班</span><span class='td'>5</span><span class='td'>1</span></ion-item>
				<ion-item><span class='td'>中三班</span><span class='td'>0</span><span class='td'>3</span></ion-item>
				<ion-item><span class='td'>小一班</span><span class='td'>0</span><span class='td'>0</span></ion-item>
				<ion-item><span class='td'>中一班</span><span class='td'>0</span><span class='td'>0</span></ion-item>
				<ion-item style='height:12px;padding: 0;background-color: #E2EEF6;border:none;'></ion-item>
			</ion-list>
		</ion-content>
		<script>
			angular.module('app', ['ionic']).controller('app', function($scope, $timeout, $ionicLoading, $http) {
				$scope.init = function() {
					loading();
					$scope.time = '2016年4月5日';
				}

				$scope.change = function(time) {
					loading();
				}

				function loading() {
					$ionicLoading.show({
						content: 'Loading',
						animation: 'fade-in',
						showBackdrop: true,
						maxWidth: 200,
						showDelay: 0
					});
					$timeout(function() {
						$ionicLoading.hide();
					}, 1000);
				}

				function loadData() {
					$http.get('', {}).success(function(result) {

					}).error(function(result) {

					});
				}
			});
			
			function back(){
				location='ReportCenter.aspx';
			}
		</script>
	</body>

</html>