import cv2 


image = cv2.imread("../out/output.bmp")
cv2.imshow('barcode', image)
cv2.waitKey(0)
cv2.destroyAllWindows()
