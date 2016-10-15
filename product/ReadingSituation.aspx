<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReadingSituation.aspx.cs" Inherits="Digicloud.DAM.Web.CI.Mobile.ReadingSituation" %>

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
		<script src="JS/Teacher.js?v=1.0"></script>
		<style>
			div.tag {
				height: 60px;
				width: 60px;
				border-radius: 30px;
				color: #FFFFFF;
				line-height: 60px;
				font-size: 25px;
				text-align: center;
				display: inline-block;
			}
			
			ion-item.odd div.tag {
				background-color: #70CDFF;
			}
			
			ion-item.even div.tag {
				background-color: #C0E6FF;
			}
			
			span.cClassName {
				font-size: 16px;
				color: #4F4F4F;
			}
			
			span.tip {
				font-size: 15px;
				color: #9A9A9A;
			}
			
			span.num {
				font-size: 15px;
				color: #D53027;
			}
			
			i.ion-ios-arrow-right {
				color: #C1C1C1;
				font-size: 25px;
				margin-right: -10px;
			}
		</style>
	</head>

	<body ng-controller='app' ng-init='init()' ng-cloak>
		<ion-header-bar class='bar-calm' style='background-color: #009BE8;background-image:url(Image/health_title.png);background-size:cover;'>
			<button class='button button-icon icon ion-ios-arrow-left' onclick="back()">返回</button>
			<h1 class='title'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;阅读情况</h1>
		</ion-header-bar>
		<ion-content style='background-color: #E2EEF6;'>
			<ion-list>
				<ion-item class='item-icon-right' style='cursor: pointer;' ng-repeat='item in readingSituations' ng-click='detail(item.cClassName)' ng-class-odd="'odd'" ng-class-even="'even'">
					<div class='tag' ng-if='item.cClassName!=""'>班</div>
					<div class='tag' ng-if='item.cClassName==""'>师</div>
					<div style='display: inline-block;position: relative;top:4.5px;left:3.5px;'>
						<span class='cClassName' ng-if='item.cClassName!=""'>{{item.cClassName}}<br /></span>
						<span class='cClassName' ng-if='item.cClassName==""'>教师<br /></span>
						<span class='tip'>已读<span class='num'>{{item.readUsersCount}}</span>人，未读<span class='num'>{{item.unReadUsersCount}}</span>人</span>
					</div>
					<i class="icon ion-ios-arrow-right"></i>
				</ion-item>
			</ion-list>
		</ion-content>
		<script>
			var iNoticeID = getQueryStringValue('id');
			var iscreater = getQueryStringValue('iscreater');
			app.controller('app', function($scope, $window, commonService, initService) {
				$scope.readingSituations = [];
				$scope.cClassNames = [];
				$scope.init = function() {
					initService.initReady($scope, function() {
						commonService.checkPagePower({
							onload: function() {
								initPage();
							}
						});
					});
				}

				$scope.detail = function(cClassName) {
					$window.location = 'ReadingSituationDetail.aspx?id='+iNoticeID+'&class='+cClassName+'&iscreater='+iscreater;
				}

				function initPage() {
					var readUsers = [];
					var unReadUsers = [];
					commonService.postData({
						url: 'DcCdNoticeManage',
						params: {
							Action: 'GetUnreadUser',
							iNoticeID: iNoticeID
						},
						success: function(ci_result) {
							if(existData(ci_result)) {
								unReadUsers = ci_result.rows;
								commonService.postData({
									url: 'DcCdNoticeManage',
									params: {
										Action: 'GetReadUser',
										iNoticeID: iNoticeID
									},
									success: function(ci_result) {
										if(existData(ci_result)) {
											readUsers = ci_result.rows;
											angular.forEach(unReadUsers, function(value, key) {
												if($scope.cClassNames.indexOf(value.cClassName) == -1) {
													$scope.cClassNames.push(value.cClassName);
												}
											});
											angular.forEach(readUsers, function(value, key) {
												if($scope.cClassNames.indexOf(value.cClassName) == -1) {
													$scope.cClassNames.push(value.cClassName);
												}
											});
											angular.forEach($scope.cClassNames, function(value, key) {
												var cClassName = value;
												var readUsersCount = 0;
												var unReadUsersCount = 0;
												angular.forEach(readUsers, function(value, key) {
													if(value.cClassName == cClassName) {
														readUsersCount++;
													}
												});
												angular.forEach(unReadUsers, function(value, key) {
													if(value.cClassName == cClassName) {
														unReadUsersCount++;
													}
												});
												$scope.readingSituations.push({
													cClassName: cClassName,
													readUsersCount: readUsersCount,
													unReadUsersCount: unReadUsersCount
												});
											});
										} else {
											commonService.showAlert('记录不存在或已删除');
										}
									}
								});
							} else {
								commonService.showAlert('记录不存在或已删除');
							}
						}
					});
				}

			});

			function back() {
				gotoApp();
			}
		</script>
	</body>

</html>