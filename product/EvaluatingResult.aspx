<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EvaluatingResult.aspx.cs" Inherits="Digicloud.DAM.Web.CI.Mobile.EvaluatingResult" %>

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
			#afreshBtn {
				color: #FFFFFF;
				background-color: #01C3FF;
				border: none;
				border-radius: 4px;
				width: 75%;
				height: 35px;
				font-size: 17px;
				line-height: 35px;
			}
			
			div.level {
				height: 17px;
				width: 17px;
				display: inline-block;
				color: #FFFFFF;
				font-size: 9px;
				font-weight: 500;
				text-align: center;
				line-height:17px;
				border-radius: 3px;
				margin-right:3px;
				position: relative;
				top:-2px;
			}
			
			div.level-1 {
				background-color: #90C652;
			}
			
			div.level-2 {
				background-color: #01C3FF;
			}
			
			div.level-3 {
				background-color: #FF823F;
			}
			
			div.level-4 {
				background-color: #E01E1D;
			}
			
			span.cOption {
				float: right;
				font-size: 14px;
				line-height: 17px;
				margin-top:5px;
			}
			
			span.cOption-1 {
				color: #90C652;
			}
			
			span.cOption-2 {
				color: #01C3FF;
			}
			
			span.cOption-3 {
				color: #FF823F;
			}
			
			span.cOption-4 {
				color: #E01E1D;
			}
			span.cSubject{
				font-size:14px;
				line-height: 17px;
			}
			p.cResult{
				margin-top:5px;
				font-size:14px;
				line-height: 20px;
				white-space: normal;
			}
			#tip{
				font-size:15px;
			}
		</style>
	</head>

	<body ng-controller='app' ng-init='init()' ng-cloak>
		<ion-header-bar class='bar-calm' style='background-color: #009BE8;background-image:url(Image/health_title.png);background-size:cover;'>
			<button class='button button-icon icon ion-ios-arrow-left' onclick="back()">返回</button>
			<h1 class='title' ng-bind-html='title' ng-cloak></h1>
		</ion-header-bar>
		<ion-content style='background-color: #E2EEF6;'>
			<ion-list>
				<ion-item ng-repeat='item in healthEvals'>
					<div ng-class='item.nClass'>{{item.cResultTypeDesc!='差'?item.cResultTypeDesc:'!'}}</div><span class='cSubject'>{{item.cSubject}}</span><span ng-class='item.cOptionClass'>{{item.cOption}}</span><br />
					<p class='cResult'>{{item.cResult}}</p>
				</ion-item>
				<ion-item id='tip' style='white-space: normal;'>
					<div style='text-align: center;'>
						<span>温馨提示</span>
					</div>
					<span>如有明显疾病症状、急症等状况 ，请及时就医！</span>
				</ion-item>
			</ion-list>
		</ion-content>
		<ion-footer-bar style='padding:10px;border-top:1px solid #DDDDDD;'>
			<h1 class='title' style='text-align: center;'>
				<button id='afreshBtn' ng-click='afresh()'>重新评测</button>
			</h1>
		</ion-footer-bar>
		<script>
			var _iType = getQueryStringValue('iType');
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

				$scope.afresh = function() {
					location.href = 'Evaluating.aspx?iType='+_iType;
				}

				function initPage() {
					if(_iType == 1) {
						$scope.title = '&nbsp;&nbsp;&nbsp;&nbsp;生活习惯评测分析';
					} else if(_iType == 2) {
						$scope.title = '&nbsp;&nbsp;&nbsp;&nbsp;日常饮食评测分析';
					} else if(_iType == 3) {
						$scope.title = '&nbsp;&nbsp;&nbsp;&nbsp;常见病测评分析';
					}
					commonService.postData({
						url: 'DcCdHealthEvalStudentManage',
						params: {
							Action: 'GetList',
							Type: 'U',
							iType:_iType
						},
						success: function(ci_result) {
							if(existData(ci_result)) {
								var m_objData = ci_result.rows;
								angular.forEach(m_objData, function(value, key) {
									if(value.iResultType == 1) {
										value.nClass = ['level', 'level-1'];
										value.cOptionClass = ['cOption', 'cOption-1'];
									} else if(value.iResultType == 2) {
										value.nClass = ['level', 'level-2'];
										value.cOptionClass = ['cOption', 'cOption-2'];
									} else if(value.iResultType == 3) {
										value.nClass = ['level', 'level-3'];
										value.cOptionClass = ['cOption', 'cOption-3'];
									} else if(value.iResultType == 4) {
										value.nClass = ['level', 'level-4'];
										value.cOptionClass = ['cOption', 'cOption-4'];
									}
								});
								$scope.healthEvals = m_objData;
							} else {
								commonService.showAlert('记录不存在或已删除');
							}
						}
					});
				}
			});
			
			function back(){
				location='HealthEvaluation.aspx';
			}
		</script>
	</body>

</html>