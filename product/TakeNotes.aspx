<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TakeNotes.aspx.cs" Inherits="Digicloud.DAM.Web.CI.Mobile.TakeNotes" %>

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
			table {
				width: 100%;
				border: 1px solid #D9D9D9;
			}
			
			tr {
				height: 30px;
			}
			
			th {
				line-height: 30px;
				text-align: center;
				background-color: #E5E5E5;
			}
			
			td {
				border: 1px solid #D9D9D9;
				text-align: center;
				line-height: 30px;
			}
		</style>
	</head>

	<body ng-controller='app' ng-init='init()' ng-cloak>
		<ion-header-bar class='bar-calm' style='background-color: #009BE8;background-image:url(Image/health_title.png);background-size:cover;'>
			<button class='button button-icon icon ion-ios-arrow-left' onclick="back()">返回</button>
			<h1 class='title'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;添加记录</h1>
		</ion-header-bar>
		<ion-content style='background-color: #E2EEF6;padding-bottom: 15px;'>
			<ion-list>
				<label class="item item-input" style='text:center;padding-left:12.5%;padding-right: 12.5%;border:none;padding-top:15px;'>
   					 日期&nbsp;&nbsp;&nbsp;<input ng-model='form.dDate' type="date" style='border:1px solid #EAEAEA;border-radius: 5px;'>
  				</label>
				<label class="item item-input" style='text:center;padding-left:12.5%;padding-right: 12.5%;border:none;'>
   					 身高&nbsp;&nbsp;&nbsp;<input ng-model='form.fHeight' type="number" style='border:1px solid #EAEAEA;border-radius: 5px;' placeholder="&nbsp;请输入身高(单位cm)">
  				</label>
				<label class="item item-input" style='text:center;padding-left:12.5%;padding-right: 12.5%;border:none;'>
   					 体重&nbsp;&nbsp;&nbsp;<input ng-model='form.fWeight' type="number" style='border:1px solid #EAEAEA;border-radius: 5px;' placeholder="&nbsp;请输入体重(单位kg)">
  				</label>
				<ion-item style='border:none;text-align: center;'>
					<button ng-click='save()' style='border:none;border-radius: 5px;background-color: #00C4FF;color:#FFFFFF;width:65%;height:30px;'>保存</button>
				</ion-item>
				<ion-item style='border:none;text-align: center;padding-top:0;'>
					<span style='font-size:14px;color:#CFCFCF;'>——————<span style='margin:0 25px;'>历史记录</span>——————</span>
				</ion-item>
				<ion-item style='border:none;'>
					<table>
						<thead>
							<tr>
								<th style='width:7%;'></th>
								<th style='width:30%;'>日期</th>
								<th style='width:30%;'>身高(cm)</th>
								<th style='width:30%;'>体重(kg)</th>
							</tr>
						</thead>
						<tbody>
							<tr ng-repeat='item in healthGrowupHistorys'>
								<td>{{$index+1}}</td>
								<td>{{item.dDate}}</td>
								<td>{{item.fHeight}}</td>
								<td>{{item.fWeight}}</td>
							</tr>
						</tbody>
					</table>
				</ion-item>
			</ion-list>
		</ion-content>
		<script>
			app.controller('app', function($scope, $window, commonService, initService) {
				$scope.form = {
					dDate:'',
					fHeight:'',
					fWeight:''
				};
				$scope.healthGrowupHistorys = [];
				$scope.init = function() {
					initService.initReady($scope, function() {
						commonService.checkPagePower({
							onload: function() {
								initPage();
							}
						});
					});
				}

				$scope.save = function() {
					if($scope.form.dDate == ''){
						commonService.showAlert('请输入日期');
						return;
					}else if($scope.form.fHeight == ''){
						commonService.showAlert('请输入身高记录');
						return;
					}else if($scope.form.fWeight == ''){
						commonService.showAlert('请输入体重记录');
						return;
					}
					commonService.postData({
						url: 'DcCdHealthGrowupManage',
						params: {
							Action: 'Add',
							Type: 'U',
							dDate: $scope.form.dDate.toLocaleDateString(),
							fHeight: $scope.form.fHeight,
							fWeight: $scope.form.fWeight
						},
						success: function(ci_result) {
							if(ci_result.DcCode == 0) {
								getHealthGrowup();
								$scope.form.dDate = '';
								$scope.form.fHeight = '';
								$scope.form.fWeight = '';
								commonService.showAlert('保存成功');
							} else {
								commonService.showAlert(ci_result.DcMessage);
							}
						}
					});
				}

				function initPage() {
					getHealthGrowup();
				}
				
				function getHealthGrowup(){
					$scope.healthGrowupHistorys = [];
					commonService.postData({
						url:'DcCdHealthGrowupManage',
						params:{
							Action:'GetList',
							Type:'U',
							page:1,
							rows:20,
							sort:'dDate',
							order:'desc'
						},
						success:function(ci_result){
							if(existData(ci_result)){
								var m_objData = ci_result.rows;
								angular.forEach(m_objData,function(value,key){
									$scope.healthGrowupHistorys.push(value);
								});
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