.data
    v:  .space 400 
    text1: .space 100
    text2: .space 100
    alfabet: .asciiz "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    ms: .asciiz "p nu e prim"
    msj: .asciiz "numarul introdus nu este mai mare decat 2"
.text
main:
    li $v0, 5               #incarc valoarea 5 in $v0 pentru a citi de la tastatura numarul p
    syscall
    li $t4, 1
    la $t2, v          
    sw $t4, 0($t2)
    move $t0, $v0           #mut in t0 valoarea introdusa de la tastatura
    li $t1, 2               #incarc valoarea 2 in $t1
    div $t3, $t0, 2         #impart valoarea la 2 pentru o parcurgere eficienta
    ble $t0, $t1, mesaj     #verific daca numarul este mai mare decat 2
            
loop:
    bge $t1, $t3, pp        #verific daca numarul introdus de la tastatura(p) are divizori in intervalul[2,p/2]
    rem $t4, $t0, $t1       #incarc in $t4 restul impartirii lui $t0 la $t1
    beq $t4, $zero, px      #restul impartirii lui $t0(p) la $t1 e zero,atunci sar la px
    addi $t1, $t1, 1        #adun 1 la $t1
    j loop
pp:
    li $t3, 8               #incarc valoarea 8 in $a3,prima pozitie a vectorului fiind deja ocupata de valoarea 1,iar pe a doua pozitie sa va afla numarul verifica
    li $t1, 2               #incarc valoarea 2 in $t1 pentru a cauta generatorul in intervalul [2,P-1]
    
bcd:
    li $t3, 8 
    bge $t1, $t0, wx      #parcurg intervalul [2,p-1] pentru a cauta generatorul
    sw $t1, 4($t2)          #salvez pe a doua pozitie numarul
    mul $t7, $t0, 4        
    move $t5, $t1
    sub $t7, $t7, 4         #in $t7 salvez pozitia la care se opreste parcurgerea
    li $s1, 0
def:
    bgt $t3, $t7, gh        #merg din 4 in 4 pentru a umple vectorul
    mul $t5, $t5, $t1       #ridic la putere generatorul
    rem $t4, $t5, $t0       #salvez in $t4 restul impartirii la p
    sw $t4, v($t3)          #salvez valoarea in vector
    addi $t3, $t3, 4        #adun 4 pentru a trece la pozitia urmatoare
    j def
gh:
    li $t3, 0               #$t3 ia vloarea 0 pentru a incepe parcurgerea de pe prima pozitie
    li $t5, 4               #$t5 ia valoarea 4 pentru a incepe de pe a doua pozitie
    mul $t6, $t0, 4
    sub $t6, $t6, 8         #$t6 reprezinta penultima pozitie a vectorului
    mul $t7, $t0, 4
    sub $t7, $t7, 4         #$t7 reprezinta ultima pozitie a vectorului
ij:
    bgt $t3, $t6, kl        #incep parcurgerea vectorului pentru a compara elementele
    lw $t4, v($t3)          #icarc in $t4 elementul
    addi $t5, $t3, 4
mn:
    bgt $t5, $t7, op       
    lw $s0, v($t5)          #incarc in $s0 elementul                        
    beq $t4, $s0, qr        #daca doua elemente sunt egale sar la qr
    addi $t5, $t5, 4        #adun 4 pentru a trece la urmatorul element
    j mn
qr:
    addi $s1, $s1, 1        #numar egalitatile din vector
    addi $t5, $t5, 4
    j mn
op:
    addi $t3, $t3, 4        #adun 4 la $t3
    j ij
kl:
    li $s6, 1               #incarc in $t6 2
    addi $t1, $t1, 1        #adun 1 la $t1 pentru a lua urmatorul numar
    bgt $s1, $s6, bcd       #daca sunt mai mult de doua elemente egale ma intorc pentru a cauta generatorul
    j wx


wx:
    move $s0, $t0        
    li $v0, 8
    la $a0, text1           #citesc de la tastatura textul care trebuie criptat
    la $a1, 100
    syscall
    li $s0, 0
    lb $s1, text1($s0)
xy:
   
    lb $s1, text2($s0)      #$s1 retine o litera a mesajului
    beqz $s1, yz
    li $t2, 0
    
aa:
    lb $t3, alfabet($t2)    #caut litera in alfabet pentru a vedea pe ce pozitie se afla
    beq $s1, $t3, bb        #daca am gasit o sar la bb
    addi $t2, $t2, 1        #trec la urmatoarea litera alfabetului in caz contrar
    j aa
bb: 
    mul $t4, $t2, 4         #in $t4 salvez produsul dintre $t2 si 4 pentru ca trec la pozitiile din vector
    lw $t6, v($t4)          #incarc in $t6 valoarea de pe pozitia $t4
    lb $t5, alfabet($t6)    #in $t5 salvez litera
    move $a0, $t5
    li $v0, 11
    syscall
    addi $s0, $s0, 1        #trec la urmatoarea litera
    j xy
yz:
    li $v0, 8
    la $a0, text2
    la $a1, 100             #citesc de la tastatura textul care urmeaza sa fie decriptat
    syscall
    li $s0, 0
try:
    lb $s1, text2($s0)      #$s1 retine o litera a mesajului
    beqz $s1, exit
    li $t2, 0
brlp:
    lb $t3, alfabet($t2)    #caut in alfabet pozitia pe care se afla litera
    beq $s1, $t3, crmc      #daca am gasit o sar la crmc
    addi $t2, $t2, 1        #trec la urmatoarea litera in caz contrar
    j brlp                  
crmc:
    li $t4, 0               
    li $t5, 100
prz:
    bgt $t4, $t5, exit      #parcurg vectorul generat de generator
    lw $t6, v($t4)          #incarc in $t6 valoarea de pe pozitia $t4
    beq $t2, $t6, prprpr    #daca am gasit valoarea sar la prprpr
    addi $t4, $t4, 4        #adun 4 pentru a trece la pozitia urmatoare
    j prz
prprpr:
    div $t1, $t4, 4         #impart la 4 pozitia pentru a ma intoarce la sir
    lb $t7, alfabet($t1)    #salvez in $t7 litera pe care trebuie sa o afisez
    move $a0, $t7
    li $v0, 11
    syscall
    addi $s0, $s0, 1        #adun a pentru a trece la urmatoarea litera a mesajului
    j try
px:
    la $a0, ms              #daca numarul nu e prim afisam mesajul
    li $v0, 4	
    syscall
    j exit
mesaj:
    la $a0, msj
    li $v0, 4
    syscall
exit:
    li $v0, 10
    syscall																																																																								
