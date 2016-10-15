<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HealthCenter.aspx.cs" Inherits="Digicloud.DAM.Web.CI.Mobile.HealthCenter" %>

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
		<style type="text/css">
			.bs-item {
				border: 1px solid #F3F3F3;
				height: 100%;
				border-radius: 5px;
				background-repeat: no-repeat;
				background-size: 45% 100%;
			}
			
			.bs-item .desc {
				margin-left: 45%;
				text-align: center;
				line-height: 65px;
				color: #6B6B6B;
			}
			
			.menu-item {
				padding: 7px;
				cursor: pointer;
			}
			
			.menu-item img {
				height: 62px;
				width: 62px;
				float: left;
				margin-right: 10px;
			}
			
			.menu-item .title {
				font-size: 15px;
			}
			
			.menu-item .desc {
				font-size: 13px;
				color: #BCBCBC;
				display: block;
				margin-top: 7px;
			}
		</style>
	</head>

	<body ng-controller='app' ng-init='init()' ng-cloak>
		<ion-header-bar class='bar-calm' style='background-color: #009BE8; background-image: url(Image/health_title.png); background-size: cover'>
			<h1 class='title' style='text-align: center;'>健康中心</h1>
		</ion-header-bar>
		<ion-content style='background-color: #E2EEF6;'>
			<ion-list>
				<ion-item style='padding:5px;line-height: 25px;'>
					<span style='color:#7C7C7C;'>今天的晨检情况<span>({{date}})</span></span>
					<button class='button button-calm button-small' style='float:right;width:30%;height:20px;' onclick='location="MorningCheckRecord.aspx"'>查看详情</button>
				</ion-item>
				<ion-item style='padding:5px;'>
					<div class='row' style='padding-left:0;'>
						<div class='col' style='text-align: center;height:75px;'>
							<div class='bs-item' style='background-image: url(Image/health_bbt.png);' ng-click='detail()'>
								<div class='desc'>
									{{cBbtStatusDesc}}
								</div>
							</div>
						</div>
						<div class='col' style='text-align: center;height:75px;'>
							<div class='bs-item' style='background-image: url(Image/health_symp.png);' ng-click='detail()'>
								<div class='desc'>
									{{cSympStatusDesc}}
								</div>
							</div>
						</div>
					</div>
				</ion-item>
				<ion-item style='height:12px;padding: 0;background-color: #E2EEF6;border:none;'></ion-item>
				<ion-item class='menu-item' onclick='location="HealthRecord.aspx"'>
					<img src="Image/health_m1.png" />
					<label class='title'>健康记录</label><br /><span class='desc'>记录孩子的疾病史、过敏史</span>
				</ion-item>
				<ion-item class='menu-item' onclick='location="HealthEvaluation.aspx"'>
					<img src="Image/health_m2.png" />
					<label class='title'>健康测评</label><br /><span class='desc'>全面了解孩子的健康情况</span>
				</ion-item>
				<ion-item class='menu-item' onclick='location="HeightIndex.aspx"'>
					<img src="Image/health_m3.png" />
					<label class='title'>健康指标</label><br /><span class='desc'>查看孩子的身高体重是否符合指标</span>
				</ion-item>
				<ion-item class='menu-item' onclick='location="ParentingEncyclopedia.aspx"' ng-if='false'>
					<img src="Image/health_m4.png" />
					<label class='title'>育儿大全</label><br /><span class='desc'>查看更多幼儿健康资讯</span>
				</ion-item>
			</ion-list>
		</ion-content>
	</body>

</html>
<script>
	app.controller('app', function($scope, $window, commonService, initService) {
		$scope.init = function() {
			initService.initReady($scope, function() {
				commonService.checkPagePower({
					onload: function() {
						initPage();
					}
				});
			});
		}
		
		$scope.detail = function(){
			var myDate = new Date();
			$window.location = 'MorningCheckDetail.aspx?date=' + myDate.getFullYear()+'-'+(myDate.getMonth()+1)+'-'+myDate.getDate()+'&interim=1';
		}

		function initPage() {
			commonService.postData({
				url: 'DcCdHealthCheckManage',
				params: {
					Action: 'GetList',
					Type: 'U',
					IsToday: true
				},
				success: function(ci_result) {
					if(existData(ci_result)) {
						var m_objData = ci_result.rows[0];
						var day = new Date();
						$scope.date = (day.getMonth() + 1) + '月' + day.getDate() + '日';
						$scope.cBbtStatusDesc = m_objData.cBbtStatusDesc;
						$scope.cSympStatusDesc = m_objData.cSympStatusDesc;
					} else {
						var day = new Date();
						$scope.date = (day.getMonth() + 1) + '月' + day.getDate() + '日';
						$scope.cBbtStatusDesc = '未检';
						$scope.cSympStatusDesc ='未检';
					}
				}
			});
		}
	});
</script>