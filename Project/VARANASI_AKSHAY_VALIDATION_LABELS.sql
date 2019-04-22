CREATE TABLE VARANASI_AKSHAY_VALIDATION_LABELS(
	
	ImageID text,
	Source text,
	LabelName text,
	Confidence int
	
);
-- Using import option imported the CSV file “validation-annotations-human-imagelabels.csv” after creating the table
--COPY varanasi_akshay_validation_labels
--FROM '/home/akshay/Desktop/Adv_Vis/Project/validation-annotations-human-imagelabels.csv' DELIMITER ',' CSV HEADER;


GRANT SELECT ON public.VARANASI_AKSHAY_VALIDATION_LABELS TO joshdr;
GRANT SELECT ON public.VARANASI_AKSHAY_VALIDATION_LABELS TO whiphi92;
