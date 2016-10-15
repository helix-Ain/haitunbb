<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ParentingEncyclopedia.aspx.cs" Inherits="Digicloud.DAM.Web.CI.Mobile.ParentingEncyclopedia" %>

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
		<style>
			span.active {
				color: #21B200;
			}
		</style>
	</head>

	<body ng-controller='app' ng-init='init()' ng-cloak>
		<ion-header-bar class='bar-calm' style='background-color: #009BE8;background-image:url(Image/health_title.png);background-size:cover;'>
			<button class='button button-icon icon ion-ios-arrow-left' onclick="back()">返回</button>
			<h1 class='title'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;育儿大全</h1>
		</ion-header-bar>
		<ion-tabs class="tabs-striped tabs-top tabs-background-light tabs-color-calm">
			<a class="tab-item" ng-class='{active:tab==1}'>
				推荐阅读
			</a>
			<a class="tab-item" ng-class='{active:tab==2}'>
				健康成长
			</a>
			<a class="tab-item" ng-class='{active:tab==3}'>
				最新活动
			</a>
		</ion-tabs>
		<ion-content class='has-tabs-top' style='background-color: #E2EEF6;'>
			<ion-list>
				<ion-item style='padding:0;height:140px;'>
					<img src="/CI/Mobile/Image/health_hl.jpg" style='width:100%;height:100%;' />
				</ion-item>
				<ion-item style='height:40px;padding:0;'>
					<div class='row'>
						<div class='col' style='text-align: center;'>
							<span ng-class='{active:assortment==1}' style='cursor:pointer;'>推荐阅读</span>
						</div>
						<div class='col' style='text-align: center;'>
							<span ng-class='{active:assortment==2}' style='cursor:pointer;'>历史文章</span>
						</div>
					</div>
				</ion-item>
				<ion-item class='item-thumbnail-left' ng-click='detail()'>
					<img src="/CI/Mobile/Image/health_blue-album.jpg" />
					<h2>Weezer</h2>
					<p>Blue Album</p>
				</ion-item>
				<ion-item class='item-thumbnail-left' ng-click='detail()'>
					<img src="/CI/Mobile/Image/health_license-to-ill.jpg" />
					<h2>Smashing Pumpkins</h2>
					<p>Siamese Dream</p>
				</ion-item>
				<ion-item class='item-thumbnail-left' ng-click='detail()'>
					<img src="/CI/Mobile/Image/health_siamese-dream.jpg" />
					<h2>Beastie Boys</h2>
					<p>License To Ill</p>
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
				location='HealthCenter.aspx';
			}
		</script>
	</body>

</html>