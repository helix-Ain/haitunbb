<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReadingSituationDetail.aspx.cs" Inherits="Digicloud.DAM.Web.CI.Mobile.ReadingSituationDetail" %>

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
			span.th {
				display: inline-block;
				width: 50%;
				text-align: center;
				font-size: 16px;
				color: #979797;
			}
			
			span.td {
				display: inline-block;
				width: 50%;
				text-align: center;
				font-size: 15px;
				color: #4F4F4F;
			}
			
			span.read {
				color: #29D133;
			}
			
			span.unread {
				color: #FF0000;
			}
			
			#remindBtn {
				color: #FFFFFF;
				background-color: #01C3FF;
				border: none;
				border-radius: 4px;
				width: 75%;
				height: 35px;
				font-size: 17px;
				line-height: 35px;
			}
			
			#tag-left {
				display: inline-block;
				width: 50%;
				text-align: right;
				position: relative;
				left: -10px;
			}
			
			#tag-right {
				display: inline-block;
				width: 50%;
				text-align: left;
				position: relative;
				right: -10px;
			}
			
			#tip-left {
				display: inline-block;
				height: 7px;
				width: 7px;
				background-color: #A3E057;
				margin-right: 5px;
				position: relative;
				top: -2px;
			}
			
			#tip-right {
				display: inline-block;
				height: 7px;
				width: 7px;
				background-color: #FADF0A;
				margin-right: 5px;
				position: relative;
				top: -2px;
			}
			
			span.tip-text {
				font-size: #969696;
			}
		</style>
	</head>

	<body ng-controller='app' ng-init='init()' ng-cloak>
		<ion-header-bar class='bar-calm' style='background-color: #009BE8;background-image:url(Image/health_title.png);background-size:cover;'>
			<button class='button button-icon icon ion-ios-arrow-left' onclick="back()">返回</button>
			<h1 class='title'>&nbsp;&nbsp;&nbsp;&nbsp;{{cClassName}}阅读情况</h1>
		</ion-header-bar>
		<ion-content style='background-color: #E2EEF6;'>
			<ion-list>
				<ion-item style='border:none;text-align: center;padding-bottom:0;'>
					<div id='tag-left'>
						<div id='tip-left'></div><span>已读</span>
					</div>
					<div id='tag-right'>
						<div id='tip-right'></div><span>未读</span>
					</div>
				</ion-item>
				<ion-item style='border:none;text-align: center;'>
					<canvas id="myChart" width="275" height="200" style='margin:0 auto;'></canvas>
				</ion-item>
				<ion-item style='border:none;text-align: center;padding-top:0;color:#969696;'>
					<span>已读{{readUsersCount}}人</span>&nbsp;&nbsp;&nbsp;&nbsp;<span>未读{{unReadUsersCount}}人</span>
				</ion-item>
				<ion-item style='height:14px;padding: 0;background-color: #E2EEF6;border:none;'></ion-item>
				<ion-item style='border-top:none;'>
					<span class='th'>姓名</span>
					<span class='th'>状态</span>
				</ion-item>
				<ion-item ng-repeat='item in readingSituations'>
					<span class='td'>{{item.cUserChiName}}</span>
					<span class='td read' ng-if='item.statusDesc=="已读"'>已读</span>
					<span class='td unread' ng-if='item.statusDesc=="未读"'>未读</span>
				</ion-item>
				<ion-item style='height:100px;background: #E2EEF6;border:none;text-align: center;height:150px;'>
					<button id='remindBtn' ng-if='iscreater' ng-click='remind()'>提醒未读用户</button>
				</ion-item>
			</ion-list>
		</ion-content>
		<script>
			var iNoticeID = getQueryStringValue('id');
			var cClassName = decodeURI(getQueryStringValue('class'));
			var iscreater = getQueryStringValue('iscreater');
			app.controller('app', function($scope, $window, commonService, initService) {
				$scope.readingSituations = [];
				$scope.cClassName = cClassName;
				if(iscreater == 1 || iscreater == '') {
					$scope.iscreater = true;
				} else {
					$scope.iscreater = false;
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

				$scope.remind = function() {
					commonService.postData({
						url: 'DcCdNoticeManage',
						params: {
							Action: 'RemindUnreadUser',
							iNoticeID: iNoticeID
						},
						success: function(ci_result) {
							if(ci_result.DcCode == 0) {
								commonService.showAlert('操作成功');
							} else {
								commonService.showAlert(ci.result.DcMessage);
							}
						}
					});
				}

				function initPage() {
					var readUsers = [];
					var unReadUsers = [];
					commonService.postData({
						url: 'DcCdNoticeManage',
						params: {
							Action: 'GetReadUser',
							iNoticeID: iNoticeID
						},
						success: function(ci_result) {
							if(existData(ci_result)) {
								var m_objData = ci_result.rows;
								angular.forEach(m_objData, function(value, key) {
									if(value.cClassName == cClassName) {
										readUsers.push(value);
									}
								});
								commonService.postData({
									url: 'DcCdNoticeManage',
									params: {
										Action: 'GetUnreadUser',
										iNoticeID: iNoticeID
									},
									success: function(ci_result) {
										if(existData(ci_result)) {
											var m_objData = ci_result.rows;
											angular.forEach(m_objData, function(value, key) {
												if(value.cClassName == cClassName) {
													unReadUsers.push(value);
												}
											});
											$scope.readUsersCount = readUsers.length;
											$scope.unReadUsersCount = unReadUsers.length;
											loadChart(readUsers.length, unReadUsers.length);
											angular.forEach(readUsers, function(value, key) {
												value.statusDesc = '已读';
											});
											angular.forEach(unReadUsers, function(value, key) {
												value.statusDesc = '未读';
											});
											$scope.readingSituations = readUsers.concat(unReadUsers);
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

				function loadChart(readUsersCount, unReadUsersCount) {
					if(readUsersCount==undefined || unReadUsersCount==undefined ||readUsersCount==''||unReadUsersCount==''){
						readUsersCount = 0;
						unReadUsersCount = 1;
					}
					if(readUsersCount==0&&unReadUsersCount==0){
						readUsersCount = 0;
						unReadUsersCount = 1;
					}
					var ctx = document.getElementById("myChart").getContext("2d");
					var data = [{
						label: '已读',
						value: readUsersCount,
						color: '#A3E057'
					}, {
						label: '未读',
						value: unReadUsersCount,
						color: '#FADF0A'
					}];
					var options = {
						segmentShowStroke: true,
						segmentStrokeColor: "#fff",
						segmentStrokeWidth: 1,
						animation: true,
						animationSteps: 100,
						animationEasing: "easeOutBounce",
						animateRotate: true,
						animateScale: true,
						onAnimationComplete: null
					}
					new Chart(ctx).Pie(data, options);
				}

			});

			function back() {
				history.back();
			}
		</script>
	</body>

</html>