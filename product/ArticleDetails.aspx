<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ArticleDetails.aspx.cs" Inherits="Digicloud.DAM.Web.CI.Mobile.ArticleDetails" %>

<!DOCTYPE html>
<html ng-app='app'>

	<head>
		<title>宝宝366</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<meta name="viewport" content="initial-scale=1, maximum-scale=1, user-scalable=no, width=device-width">
		<link rel='stylesheet' href='CSS/Ionic/ionic.min.css' />
		<script src="JS/Ionic/ionic.bundle.min.js"></script>
		<script src="JS/Constants.js"></script>
		<script src="JS/Common.min.js?v=1.0"></script>
		<script src="JS/Health.js?v=1.0"></script>
	</head>

	<body ng-controller='app' ng-init='init()' ng-cloak>
		<ion-header-bar class='bar-calm' style='background-color: #009BE8;background-image:url(Image/health_title.png);background-size:cover;'>
			<button class='button button-icon icon ion-ios-arrow-left' onclick="back()">返回</button>
			<h1 class='title'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;育儿大全</h1>
		</ion-header-bar>
		<ion-content style='background-color: #E2EEF6;padding-bottom: 15px;'>
			<ion-list>
				<ion-item style='text-align: center;border:none;padding-bottom: 5px;'>
					<h2 style='color:#787878;letter-spacing: 1px;'>决定孩子命运的九大关键问题</h2>
				</ion-item>
				<ion-item style='border:none;padding:0px;'>
					<hr width="85%"/>
				</ion-item>
				<ion-item style='border:none;'>
					<p style='white-space: normal;letter-spacing: 1px;text-indent: 2em;line-height: 25px;'>
						你可以不是天才，但你可以是天才的父母！树立做父母正确的家庭教育观念，为孩子建造一个良好的人生平台，让孩子有很好的人格修养，懂得做人，懂得成功的真正含义。<br/>&nbsp;&nbsp;&nbsp;&nbsp;简单方便，容易操作，适合于每一位孩子家长。 在孩子的成长中，高分数、好成绩并不代表一切。事实上，一些决定孩子命运的关键问题常常被我们忽略，它们才是孩子未来的保障。父母的目光不能只盯在暂时的成绩上，孩子要进行的是一场人生的、持久的接力赛，谁笑到最后，谁笑得最好!只有解决了教育的关键问题，才能找到正确的发展方向，才能积蓄竞争力，打好持久战! <br/>&nbsp;&nbsp;&nbsp;&nbsp;试想，如果一个孩子缺少对生命的认知(一遇到挫折就产生轻生的念头 )，没有梦想的能力(自己将来想做什么都不知道)，不懂得保护自己(做了博士生依然被农民拐卖)，无法与别人共享(腰缠万贯却不快乐)，那么，即使这个孩子门门功课考第一，又能怎么样？
					</p>
				</ion-item>
			</ion-list>
		</ion-content>
		<script>
			app.controller('app', function($scope, $window, commonService, initService) {
				$scope.tab = 1;
				$scope.assortment = 1;
				$scope.detail = function() {
					$window.location = 'ArticleDetails.aspx';
				}
				$scope.init = function() {
					initService.initReady($scope, function() {
						commonService.checkPagePower({
							onload: function() {
								initPage();
							}
						});
					});
				}

				function initPage() {

				}
			});
			function back(){
				history.back();
			}
		</script>
	</body>

</html>