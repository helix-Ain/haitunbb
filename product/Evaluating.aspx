<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Evaluating.aspx.cs" Inherits="Digicloud.DAM.Web.CI.Mobile.Evaluating" %>

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
			#previousBtn,
			#nextBtn,
			#doneBtn {
				color: #FFFFFF;
				background-color: #01C3FF;
				border: none;
				border-radius: 4px;
				width: 45%;
				height: 35px;
				font-size: 17px;
				line-height: 35px;
			}
		</style>
	</head>

	<body ng-controller='app' ng-init='init()' ng-cloak>
		<ion-header-bar class='bar-calm' style='background-color: #009BE8;background-image:url(Image/health_title.png);background-size:cover;'>
			<button class='button button-icon icon ion-ios-arrow-left' onclick="back()">返回</button>
			<h1 class='title'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;健康评测</h1>
		</ion-header-bar>
		<ion-content style='background-color: #E2EEF6;padding-bottom: 15px;'>
			<ion-list>
				<ion-item style='text-align: center;border:none;'>
					<h2 style='white-space: normal;'>{{cSubject}}</h2>
				</ion-item>
				<ion-item ng-repeat='item in cOptions' ng-click='choose(item.iID)'>
					<span style='white-space: normal;'>{{item.cOption}}</span>
					<img ng-src="{{item.src}}" style='float:right;width:20px;height:20px;cursor:pointer;' />
				</ion-item>
				<ion-item>
					<span style='white-space: normal;color:#C0C0C0;'>说明：{{cExplain}}</span>
				</ion-item>
			</ion-list>
		</ion-content>
		<ion-footer-bar style='padding:10px;border-top:1px solid #DDDDDD;'>
			<h1 class='title' style='text-align: center;'>
				<button id='previousBtn' ng-show='previousBtn' ng-click='previous()'>上一题</button>
				<button id='nextBtn' ng-show='nextBtn' ng-click='next()'>下一题</button>
				<button id='doneBtn' ng-show='doneBtn' ng-click='done()'>完成</button>
			</h1>
		</ion-footer-bar>
		<script>
			var _iType = getQueryStringValue('iType');
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

				$scope.choose = function(iOptionID) {
					if($scope.action == 'Add') {
						commonService.postData({
							url: 'DcCdHealthEvalStudentManage',
							params: {
								Action: 'Add',
								Type: 'U',
								iOptionID: iOptionID
							},
							success: function(ci_result) {
								if(ci_result.DcCode == 0) {
									angular.forEach($scope.cOptions, function(value, key) {
										if(value.iID == iOptionID) {
											value.src = '/CI/Mobile/Image/health_gouxuan.png';
										} else {
											value.src = '/CI/Mobile/Image/health_weigouxuan.png';
										}
									});
								} else {
									commonService.showAlert(ci_result.DcMessage);
								}
							}
						});
					} else if($scope.action == 'Update') {
						commonService.postData({
							url: 'DcCdHealthEvalStudentManage',
							params: {
								Action: 'Update',
								iID: $scope.resultID,
								iOptionID: iOptionID
							},
							success: function(ci_result) {
								if(ci_result.DcCode == 0) {
									angular.forEach($scope.cOptions, function(value, key) {
										if(value.iID == iOptionID) {
											value.src = '/CI/Mobile/Image/health_gouxuan.png';
										} else {
											value.src = '/CI/Mobile/Image/health_weigouxuan.png';
										}
									});
								} else {
									commonService.showAlert(ci_result.DcMessage);
								}
							}
						})
					}
				}

				$scope.previous = function() {
					commonService.postData({
						url: 'DcCdHealthEvalManage',
						params: {
							Action: 'GetList',
							iType: _iType,
							page: --$scope.currNo,
							rows: 1,
							sort: 'iOrderNo',
							order: 'asc'
						},
						success: function(ci_result) {
							if(existData(ci_result)) {
								var m_objData = ci_result.rows[0];
								$scope.iID = m_objData.iID;
								$scope.cSubject = m_objData.cSubject;
								$scope.cExplain = m_objData.cExplain;
								$scope.nextBtn = true;
								$scope.doneBtn = false;
								if($scope.currNo == 1) {
									$scope.previousBtn = false;
								}
								commonService.postData({
									url: 'DcCdHealthEvalOptionManage',
									params: {
										Action: 'GetList',
										iEvalID: $scope.iID
									},
									success: function(ci_result) {
										if(existData(ci_result)) {
											var m_objData = ci_result.rows;
											$scope.cOptions = [];
											angular.forEach(m_objData, function(value, key) {
												value.src = '/CI/Mobile/Image/health_weigouxuan.png';
												$scope.cOptions.push(value);
											});
											commonService.postData({
												url: 'DcCdHealthEvalStudentManage',
												params: {
													Action: 'GetList',
													Type: 'U',
													iEvalID: $scope.iID
												},
												success: function(ci_result) {
													if(existData(ci_result)) {
														var m_objData = ci_result.rows[0];
														$scope.resultID = m_objData.iID;
														angular.forEach($scope.cOptions, function(value, key) {
															if(value.iID == m_objData.iOptionID) {
																value.src = '/CI/Mobile/Image/health_gouxuan.png';
															}
														});
														$scope.resultID = m_objData.iID;
														$scope.action = 'Update';
													} else {
														$scope.action = 'Add';
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

				$scope.next = function() {
					commonService.postData({
						url: 'DcCdHealthEvalManage',
						params: {
							Action: 'GetList',
							iType: _iType,
							page: ++$scope.currNo,
							rows: 1,
							sort: 'iOrderNo',
							order: 'asc'
						},
						success: function(ci_result) {
							if(existData(ci_result)) {
								var m_objData = ci_result.rows[0];
								$scope.iID = m_objData.iID;
								$scope.cSubject = m_objData.cSubject;
								$scope.cExplain = m_objData.cExplain;
								$scope.previousBtn = true;
								if($scope.currNo == $scope.totalNo) {
									$scope.nextBtn = false;
									$scope.doneBtn = true;
								}
								commonService.postData({
									url: 'DcCdHealthEvalOptionManage',
									params: {
										Action: 'GetList',
										iEvalID: $scope.iID
									},
									success: function(ci_result) {
										if(existData(ci_result)) {
											var m_objData = ci_result.rows;
											$scope.cOptions = [];
											angular.forEach(m_objData, function(value, key) {
												value.src = '/CI/Mobile/Image/health_weigouxuan.png';
												$scope.cOptions.push(value);
											});
											commonService.postData({
												url: 'DcCdHealthEvalStudentManage',
												params: {
													Action: 'GetList',
													Type: 'U',
													iEvalID: $scope.iID
												},
												success: function(ci_result) {
													if(existData(ci_result)) {
														var m_objData = ci_result.rows[0];
														$scope.resultID = m_objData.iID;
														angular.forEach($scope.cOptions, function(value, key) {
															if(value.iID == m_objData.iOptionID) {
																value.src = '/CI/Mobile/Image/health_gouxuan.png';
															}
														});
														$scope.resultID = m_objData.iID;
														$scope.action = 'Update';
													} else {
														$scope.action = 'Add';
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

				$scope.done = function() {
					location.href = 'EvaluatingResult.aspx?iType='+_iType;
				}

				function initPage() {
					commonService.postData({
						url: 'DcCdHealthEvalManage',
						params: {
							Action: 'GetList',
							iType: _iType,
							page: 1,
							rows: 1,
							sort: 'iOrderNo',
							order: 'asc'
						},
						success: function(ci_result) {
							if(existData(ci_result)) {
								var m_objData = ci_result.rows[0];
								$scope.iID = m_objData.iID;
								$scope.cSubject = m_objData.cSubject;
								$scope.cExplain = m_objData.cExplain;
								$scope.totalNo = ci_result.total;
								$scope.currNo = 1;
								if($scope.totalNo > 1) {
									$scope.nextBtn = true;
								} else {
									$scope.done = true;
								}
								commonService.postData({
									url: 'DcCdHealthEvalOptionManage',
									params: {
										Action: 'GetList',
										iEvalID: $scope.iID
									},
									success: function(ci_result) {
										if(existData(ci_result)) {
											var m_objData = ci_result.rows;
                                            $scope.cOptions = [];
											angular.forEach(m_objData, function(value, key) {
												value.src = '/CI/Mobile/Image/health_weigouxuan.png';
												$scope.cOptions.push(value);
											});
											commonService.postData({
												url: 'DcCdHealthEvalStudentManage',
												params: {
													Action: 'GetList',
													Type: 'U',
													iEvalID: $scope.iID
												},
												success: function(ci_result) {
													if(existData(ci_result)) {
														var m_objData = ci_result.rows[0];
														angular.forEach($scope.cOptions, function(value, key) {
															if(value.iID == m_objData.iOptionID) {
																value.src = '/CI/Mobile/Image/health_gouxuan.png';
															}
														});
														$scope.resultID = m_objData.iID;
														$scope.action = 'Update';
													} else {
														$scope.action = 'Add';
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
				location='HealthEvaluation.aspx';
			}
		</script>
	</body>

</html>