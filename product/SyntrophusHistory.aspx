﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SyntrophusHistory.aspx.cs" Inherits="Digicloud.DAM.Web.CI.Mobile.SyntrophusHistory" %>

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
			<h1 class='title'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;遗传病史</h1>
		</ion-header-bar>
		<ion-content style='background-color: #E2EEF6;padding-bottom: 15px;'>
			<ion-list>
				<section ng-repeat='item in heredityTypes'>
					<ion-item class='item-divider'>
						{{item.cDesc}}
					</ion-item>
					<ion-item ng-repeat='item in hereditys[item.cCodeItem]'>
						{{item.cDesc}}
						<img ng-click='change(item.cCodeItem)' ng-src='{{switchs[item.cCodeItem].src}}' style='float:right;width:20px;height:20px;cursor:pointer;' />
					</ion-item>
					</ion-item>
				</section>
				<ion-item>
					<textarea rows='5' style='resize: none;border:1px solid #959595;width:100%;border-radius: 5px;' ng-model='app.cOtherHeredity'></textarea>
				</ion-item>
			</ion-list>
		</ion-content>
		<ion-footer-bar style='padding:10px;border-top:1px solid #DDDDDD;'>
			<h1 class='title' style='text-align: center;'>
				<button ng-click='save()' style='color:#FFFFFF;background-color:#01C3FF;border:none;border-radius: 5px;width:85%;height:35px;font-size:17px;line-height:35px;'>保存</button>
			</h1>
		</ion-footer-bar>
		<script>
			app.controller('app', function($scope, $window, commonService, initService) {
				$scope.heredityTypes = [];
				$scope.hereditys = [];
				$scope.switchs = [];
				$scope.app = {
					cOtherHeredity:''
				};
				$scope.init = function() {
					initService.initReady($scope, function() {
						commonService.checkPagePower({
							onload: function() {
								initPage();
							}
						});
					});
				}
				$scope.change = function(cCodeItem) {
					if($scope.switchs[cCodeItem].on) {
						$scope.switchs[cCodeItem].on = false;
						$scope.switchs[cCodeItem].src = '/CI/Mobile/Image/health_weigouxuan.png';
					} else {
						if(cCodeItem==1){
							angular.forEach($scope.switchs,function(value,key){
								value.on = false;
								value.src = '/CI/Mobile/Image/health_weigouxuan.png';
							});
						}else{
							$scope.switchs[1].on = false;
							$scope.switchs[1].src = '/CI/Mobile/Image/health_weigouxuan.png';
						}
						$scope.switchs[cCodeItem].on = true;
						$scope.switchs[cCodeItem].src = '/CI/Mobile/Image/health_gouxuan.png';
					}
				}
				$scope.save = function() {
					var cHeredity = [];
					angular.forEach($scope.switchs, function(value, key) {
						if(value.on) {
							cHeredity.push(key)
						}
					});
					commonService.postData({
						url: 'DcCdHealthStudentManage',
						params: {
							Action: 'Update',
							Type: 'U',
							cHeredity: cHeredity.join(','),
							cOtherHeredity: $scope.app.cOtherHeredity
						},
						success: function(ci_result) {
							if(ci_result.DcCode == 0) {
								commonService.showAlert('保存成功');
							} else {
								commonService.showAlert(ci_result.DcMessage);
							}
						}
					});
				}

				function initPage() {
					commonService.postData({
						url: '../../Ajax/DcCdCodeMasterManage',
						params: {
							Action: 'Combo',
							Cat: 'Health',
							SubCat: 'HeredityType'
						},
						success: function(ci_result) {
							if(existData(ci_result)) {
								var m_objData = ci_result.rows;
								$scope.heredityTypes = m_objData;
								angular.forEach(m_objData, function(value, key) {
									$scope.hereditys[value.cCodeItem] = [];
								});
								commonService.postData({
									url: '../../Ajax/DcCdCodeMasterManage',
									params: {
										Action: 'Combo',
										Cat: 'Health',
										SubCat: 'Heredity'
									},
									success: function(ci_result) {
										if(existData(ci_result)) {
											var m_objData = ci_result.rows;
											angular.forEach(m_objData, function(value, key) {
												$scope.hereditys[value.fValue1].push(value);
												$scope.switchs[value.cCodeItem] = {
													on: false,
													src: '/CI/Mobile/Image/health_weigouxuan.png'
												};
											});
											commonService.postData({
												url:'DcCdHealthStudentManage',
												params:{
													Action:'GetList',
													Type:'U'
												},
												success:function(ci_result){
													if(existData(ci_result)){
														var m_objData = ci_result.rows[0];
														var cHeredity = m_objData.cHeredity.split(',');
														angular.forEach(cHeredity,function(value,key){
															$scope.switchs[value] = {
																on:true,
																src:'/CI/Mobile/Image/health_gouxuan.png'
															};
														});
														$scope.app.cOtherHeredity = m_objData.cOtherHeredity;
													}else{
														commonService.showAlert('记录不存在或已删除');
													}
												}
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
			
			function back(){
				history.back();
			}
		</script>
	</body>

</html>