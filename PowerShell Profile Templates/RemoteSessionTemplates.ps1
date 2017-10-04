#----------------------------------------------------#
# Connect to Office 365 Production Tenant
#----------------------------------------------------#
Connect-DOMAINProdOffice365Tenant
Connect-DOMAINProdOffice365ComplianceTenant

#----------------------------------------------------#
# Connect to Office 365 Dev Test Tenant
#----------------------------------------------------#
Connect-TESTDOMAINOffice365Tenant

#----------------------------------------------------#
# Connect to Exchange 2013 Production on premise 
#----------------------------------------------------#
Connect-DOMAINProdOnPrem2013

#----------------------------------------------------#
# Connect to Exchange 2010 Production on premise 
#----------------------------------------------------#
Connect-DOMAINProdOnPrem2010

#----------------------------------------------------#
# Connect to Skype for Business Online Production
#----------------------------------------------------#
Connect-DOMAINSkypeForBusinessOnlineProd

#----------------------------------------------------#
# Connect to Skype for Business Online Dev Test
#----------------------------------------------------#
Connect-DOMAINSkypeForBusinessOnlineTest

#----------------------------------------------------#
# Disconnect session command
#----------------------------------------------------#
Close-Connections