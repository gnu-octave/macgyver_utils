### DO NOT TOUCH!!!
clear
close all
#graphics_toolkit ("gnuplot")
#graphics_toolkit ("fltk")
###


### EINSTELLUNGEN - PLEASE TOUCH
anzahl      = 2e6 #Vektorlänge der Zufallszahlen
durchlaeufe = 2
V_soll      = 3.3 #V
###


### ANGABE [dB] UND UMRECHNUNG [%] DER UNSICHERHEITEN - PLEASE TOUCH
### BERECHNUNG ERFOLGT IN PROZENT!!!

#dB.test          = 1.00;             	Unsicherheit in dB
#prozent.test     = 10^(test/20);	Unsicherheit in % (wird unbedingt benötigt!!!)
#verteilung.test  = "n";              	möglich sind "n"=Normalverteilung, "r"=Rechteckverteilung, "u"=Sinusoidalverteilung(U-Verteilung)

volt.rauschen       	= 100e-9;
prozent.rauschen	= volt.rauschen/V_soll;
verteilung.rauschen 	= "n";

volt.multimeter       	= 0.1;
prozent.multimeter	= volt.multimeter/V_soll;
verteilung.multimeter 	= "r";

###

#### Schleifenanfang
parfor x = 1:durchlaeufe
####

### ZUFALLSZAHLENERSTELLUNG - DO NOT TOUCH!!!

elemente = fieldnames (prozent);
for y = 1:numel(elemente);
u.(elemente{y})=generator(prozent.(elemente{y}),verteilung.(elemente{y}),anzahl);
end

###


### MODELLGLEICHUNG - PLEASE TOUCH

p = u.rauschen .* u.multimeter;
k = p * V_soll;
###


### ERZEUGUNG DER MITTELWERTE UND STANDARDABWEICHUNGEN
Mittelwert(x) = mean(k);
Standardabweichung(x) = std(k);
#Standardabweichung_k_2(x)=2*std(k_2);
###


### HISTOGRAMM FÜR JEDEN DURCHLAUF - Falls nicht benötigt mit "#" auskommentieren
figure(x)
hist(k,101,1)
#axis([-2 2 0 0.05])
grid minor
###

## Zusammenfügen der Vektoren für spätere Analyse
if (x == 1)
l = k;
else
l = [l; k];
end
##

#### Schleifenende
end
####

## Mittelwert und Standardabweichung der Mittelwerte der Durchläufe
m_Mittelwert = mean(Mittelwert)
u_Mittelwert = std(Mittelwert)
##

## Mittelwert und Standardabweichung der Standardabweichungen der Durchläufe
m_Standardabweichung = mean(Standardabweichung)
u_Standardabweichung = std(Standardabweichung)
##

### shortest coverage interval
printf('\n Berechne Unsicherheit nach GUM S1(shortest coverage Interval)...\n\tk=1\n')
[Unsicherheitsspannweite, Unsicherheit_nach_links, Unsicherheit_nach_rechts] = scovint(l, 0.6827)
printf('\n Berechne Unsicherheit nach GUM S1(shortest coverage Interval)...\n\tk=2\n')
[Unsicherheitsspannweite, Unsicherheit_nach_links, Unsicherheit_nach_rechts] = scovint(l, 0.95)
Unsicherheit_nach_links-V_soll
Unsicherheit_nach_rechts-V_soll
###