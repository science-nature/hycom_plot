;*****************************************************
; trimesh_1.ncl
;
; Concepts illustrated:
;   - Contouring one-dimensional X, Y, Z data
;   - Selecting a "rainbow" color map that also contains "gray"
;   - Spanning part of a color map for contour fill
;   - Drawing a map using the high resolution map outlines

;*****************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin
;
;  This data is from the Chesapeake Community Model Program Quoddy
;  model:
;
;    http://ccmp.chesapeake.org
;
;  using the NOAA/NOS standardized hydrodynamic model NetCDF format:
;
;    https://sourceforge.net/projects/oceanmodelfiles
;

  f = addfile("hycomRe.nc","r")
  
;;; get data from nc data
  lon=f->LON
  lat=f->LAT
  temp=short2flt(f->WATER_TEMP(0,0,:,:))
 
  

;;; set lon lat in temp 
  temp!0="lat"
  temp!1="lon"

  temp&lon=lon
  temp&lat=lat

  temp&lat@units="degrees_north"
  temp&lon@units="degrees_east"


;;; set missing value 
  temp@_FillValue=9999
  temp@missing_value=9999








;;; show in windows 
  wks = gsn_open_wks("x11","fvcom_td")

;;; no show save in dir 
;  wks = gsn_open_wks("png","nclhycom")

;;;
  gsn_define_colormap(wks,"rainbow+gray")



  res                     = True
  res@gsnMaximize         = True
  res@gsnSpreadColors     = True

  res@gsnDraw  = True
  res@gsnFrame = True





  res@cnFillOn            = True        ; Turn on contour fill.
  res@cnLinesOn           = False       ; Turn off contour lines

  res@lbOrientation       = "Vertical"  ; Change location of labelbar.
  res@lbLabelAutoStride   = False


  res@gsnAddCyclic                = False            ; regional data, don't add pt

  res@gsnMaximize                 = True             ; fig size maximize
  res@gsnSpreadColors             = True             ; use full color map

  res@cnCellFillEdgeColor           = 1
  res@cnCellFillMissingValEdgeColor = "white"

  

  res@mpDataBaseVersion     = "HighRes"     ; "MediumRes" will run faster.
; res@mpDataBaseVersion     = "MediumRes"     ; "MediumRes" will run faster.
  res@mpLimitMode           = "LatLon"

  res@mpMinLonF             = 115
  res@mpMaxLonF             = 123
  res@mpMinLatF             = 21
  res@mpMaxLatF             = 26

  res@tiMainString          = "hycom"
  res@tiMainOffsetYF        = -0.01           ; Move the title down.

  res@pmTickMarkDisplayMode = "Always"        ; Turn on map tickmarks.

  res@gsnRightStringOrthogonalPosF = 0.01     ; Move the subtitles down
  res@gsnLeftStringOrthogonalPosF  = 0.01     ; a little bit.
  

  res@cnLevelSelectionMode        = "ManualLevels"   ; set manual contour levels
  res@cnMinLevelValF              = 15             ; set min contour level
  res@cnMaxLevelValF              = 25             ; set max contour level
  res@cnLevelSpacingF             = 1              ; contour spacing

  map = gsn_csm_contour_map(wks,temp,res)


end
