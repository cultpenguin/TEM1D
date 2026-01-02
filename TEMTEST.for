CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
C   This program reads all parameters form a file written by MATLAB.
C   Then calls the subroutine for responses and derivatives.
C   Then writes the results to a file to be read by MATLAB.
C
C   18.11.2024 / NBC
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      PROGRAM TEMTEST
C ----------
      IMPLICIT REAL*8 (A-H,O-Z)
      IMPLICIT INTEGER*4 (I-N)
C ----------
      INCLUDE 'ARRAYSDIMBL.INC'
C ----------
      INTEGER*4 NFILT,IPMOD,IREP
C ----------
      REAL*8 RHON(N_ARR),DEPN(N_ARR)
      REAL*8 CHAIP(N_ARR),TAUIP(N_ARR),POWIP(N_ARR)
      REAL*8 XPOLY(N_ARR),YPOLY(N_ARR)
      REAL*8 XP(N_ARR),YP(N_ARR),TWAVE(N_ARR),AWAVE(N_ARR)
      REAL*8 FILTFREQ(16)
      REAL*8 TIMESOUT(N_ARR),RESPOUT(N_ARR),DRESPOUT(N_ARR,N_ARR)
C ----------
      CHARACTER*128 LBLMOD,LBLINSTR,LBLPOLY,LBLRESP,LBLIP,LBLWAVE
C ----------
      REAL*8 PI
      DATA PI /3.14159265358979D0/
C ----------

C==============================================
C --- OPEN INPUT AND OUTPUT FILES
C==============================================

C----------------------------------------------------------------------------
C --- OPEN FILE FROM WHICH PARAMETERS ARE READ
C----------------------------------------------------------------------------
      OPEN (UNIT=7,FILE='FORREAD',ACCESS='SEQUENTIAL',RECL=4096)

C----------------------------------------------------------------------------
C --- OPEN FILE TO WHICH PARAMETERS ARE WRITTEN TO BE READ FROM MATLAB
C --- CANBE OPENED HERE, I SUPPOSE ...
C----------------------------------------------------------------------------
      OPEN (UNIT=8,FILE='FORWRITE',ACCESS='SEQUENTIAL',RECL=4096)

C----------------------------------------------------------------------------
C --- OPEN DEFAULT MODEL FILE FOR OTHER OUTPUT ... MAYBE
C----------------------------------------------------------------------------
      OPEN (UNIT=21,FILE='OUT',ACCESS='SEQUENTIAL',RECL=1024)

C...............................................................................
      IWRITE21 = 1
C --- IWRITE21 = [1 | 0] : [Write to file OUT, UNIT 21 | Do not write].
C...............................................................................

C...............................................................................
      IWRI = 1
C...............................................................................
      IF (IWRI.EQ.1) THEN
      WRITE (*,*) 'TEM1DPROG ENTERED'
      WRITE (*,*) 'FILES OPENED'
      ENDIF
C...............................................................................

C========================================================================
C --- READING BEGINS HERE
C========================================================================

C=========================================================
C --- Reading model parameters
C=========================================================
      READ (7,'(A)') LBLMOD

      READ (7,*) IMLM
      READ (7,*) NLAY
      DO I = 1,NLAY
      READ (7,*) RHON(I),DEPN(I)
      ENDDO

C...............................................................................
      IF (IWRI.EQ.1) THEN
      WRITE (*,*) 'MODEL PARAMETERS READ'
      ENDIF
C...............................................................................
      WRITE (21,'(A)') LBLMOD

C=========================================================
C --- Reading IP parameters
C=========================================================
      READ (7,'(A)') LBLIP

      READ (7,*) IMODIP
      IF (IMODIP.GT.0) THEN
        DO I = 1,NLAY
        READ (7,*) CHAIP(I),TAUIP(I),POWIP(I)
        ENDDO
      ENDIF

C...............................................................................
      IF (IWRI.EQ.1) THEN
      WRITE (*,*) 'IP PARAMETERS READ'
      ENDIF
C...............................................................................
      WRITE (21,'(A)') LBLIP

C=========================================================
C --- Reading instrument parameters
C=========================================================
      READ (7,'(A)') LBLINSTR

      READ (7,*) TXAREA
      TXRAD = SQRT(TXAREA/PI)
      
      READ (7,*) ISHTX1
      READ (7,*) ISHRX1
      READ (7,*) ISHTX2
      READ (7,*) ISHRX2

      READ (7,*) HTX1
      READ (7,*) HRX1
      READ (7,*) HTX2
      READ (7,*) HRX2
      
      READ (7,*) RTXRX
      READ (7,*) IZEROPOS

      ICEN = 0
      IF (RTXRX.LT.0.001D0) THEN
        ICEN = 1
      ENDIF

C...............................................................................
      IF (IWRI.EQ.1) THEN
      WRITE (*,*) 'INSTRUMENT PARAMETERS READ'
      ENDIF
C...............................................................................
      WRITE (21,'(A)') LBLINSTR

C=========================================================
C --- Reading polygonal loop parameters
C=========================================================
      READ (7,'(A)') LBLPOLY

      READ (7,*) NPOLY

      IF (NPOLY.GT.0) THEN
        DO I = 1,NPOLY
        READ (7,*) XPOLY(I), YPOLY(I)
        ENDDO
        READ (7,*) X0RX
        READ (7,*) Y0RX
        READ (7,*) Z0RX
      ENDIF
      
C...............................................................................
      IF (IWRI.EQ.1) THEN
      WRITE (*,*) 'POLY PARAMETERS READ'
      ENDIF
C...............................................................................
      WRITE (21,'(A)') LBLPOLY

C=========================================================
C --- Reading response parameters
C=========================================================
      READ (7,'(A)') LBLRESP

      READ (7,*) IRESPTYPE
      READ (7,*) IDERIV
      READ (7,*) IWCONV
      READ (7,*) IREP

      IF (IREP.GT.0) THEN
        READ (7,*) REPFREQ
      ENDIF

      READ (7,*) NFILT
      IF (NFILT.GT.0) THEN
        DO I = 1,NFILT
        READ (7,*) FILTFREQ(I)
        ENDDO
      ENDIF

C...............................................................................
      IF (IWRI.EQ.1) THEN
      WRITE (*,*) 'RESPONSE PARAMETERS READ'
      ENDIF
C...............................................................................
      WRITE (21,'(A)') LBLRESP

C=========================================================
C --- >> WAVEFORM PARAMETERS <<
C --- UPDATED 30.10 2024 AFTER CHANGING IT IN MATLAB CODE
C=========================================================
      READ (7,'(A)') LBLWAVE

      READ (7,*) NWAVE
      IF (NWAVE.GT.0) THEN
        DO I = 1,NWAVE
        READ (7,*) TWAVE(I),AWAVE(I)
        ENDDO
      ENDIF

C...............................................................................
      IF (IWRI.EQ.1) THEN
      WRITE (*,*) 'WAVEFORM PARAMETERS READ'
      WRITE (*,*) 'READING ALL FORREAD PARAMETERS DONE'
      ENDIF
C...............................................................................
      WRITE (21,*) 'READING ALL FORREAD PARAMETERS DONE'

C======================================================================
C --- In this formulation, all output will be from this program.
C --- There will be no output from TEM1D itself.
C======================================================================
      T1 = STIMER(DUMMY)

      CALL TEM1D (
     # IMLM,NLAY,RHON,DEPN,
     # IMODIP,CHAIP,TAUIP,POWIP,
     # TXAREA,RTXRX,IZEROPOS,
     # ISHTX1,ISHTX2,ISHRX1,ISHRX2,HTX1,HTX2,HRX1,HRX2,
     # NPOLY,XPOLY,YPOLY,X0RX,Y0RX,
     # IRESPTYPE,IDERIV,IREP,IWCONV,NFILT,REPFREQ,FILTFREQ,
     # NWAVE,TWAVE,AWAVE,
     # NTOUT,TIMESOUT,RESPOUT,DRESPOUT)

C....................................................................
      T2 = STIMER(DUMMY)
      WRITE (*,*)  'CALCULATION TIME: ',T2-T1
      IF (IWRITE21.EQ.1) THEN
      WRITE (21,*) 'CALCULATION TIME: ',T2-T1
      ENDIF
C....................................................................

C****************************************************************************
C===========================================================================
C --- OUTPUT FROM THE PROGRAM.
C --- THE SUBROUTINE TEM1D PRODUCES NO OUTPUT.
C===========================================================================
C****************************************************************************

C============================================================
C --- WRITE SETTINGS TO OUTPUT FILE: OUT
C============================================================
      IF (IWRITE21.EQ.1) THEN
      
      WRITE (21,'(A)') ' '
      WRITE (21,'(A)') ' '
      WRITE (21,'(A)') '=============================================='
      WRITE (21,'(A)') '  >> THE MODEL BLOCK <<'
      WRITE (21,'(A)') '=============================================='
      WRITE (21,'(A)') ' IMLM, NLAY:'
      WRITE (21,'(3X,I1,3X,I2)')    IMLM, NLAY
      WRITE (21,'(A)') ' RHON, DEPN:'
      WRITE (21,3002)  (RHON(J),J=1,NLAY)
      WRITE (21,3002)  (DEPN(J),J=1,NLAY)
      WRITE (21,'(A)') '=============================================='

C***************************************************************
      WRITE (21,'(A)') ' '
      WRITE (21,'(A)') '=============================================='
      WRITE (21,'(A)') '  >> THE INSTRUMENT BLOCK <<'
      WRITE (21,'(A)') '=============================================='
      WRITE (21,'(A)') ' ICEN, IZEROPOS:'
      WRITE (21,'(3X,I1,2X,4X,I1)')    ICEN, IZEROPOS
      WRITE (21,'(A)') ' TXAREA ,  TXRAD ,   RTXRX:'
      WRITE (21,'(4(1X,F7.3,1X))')
     #            TXAREA,TXRAD,RTXRX
      WRITE (21,'(A)') '  HTX1 , HTX2 , HRX1 , HRX2:'
      WRITE (21,'(4(1X,F5.2,1X))') HTX1,HTX2,HRX1,HRX2
      WRITE (21,'(A)') ' ISHTX1, ISHTX2, ISHRX1, ISHRX2:'
      WRITE (21,'(4(3X,I2,3X))') ISHTX1, ISHTX2, ISHRX1, ISHRX2
      WRITE (21,'(A)') '=============================================='

C***************************************************************
      IF (IMODIP.GT.0) THEN
      WRITE (21,'(A)') ' '
      WRITE (21,'(A)') '=============================================='
      WRITE (21,'(A)') '  >> THE IP BLOCK <<'
      WRITE (21,'(A)') '=============================================='
      WRITE (21,'(A)') ' CHARGEABILITIES:'
      WRITE (21,3002)    (CHAIP(J),J=1,NLAY)
      WRITE (21,'(A)') ' TIME CONSTANTS:'
      WRITE (21,3002)    (TAUIP(J),J=1,NLAY)
      WRITE (21,'(A)') ' POWERS :'
      WRITE (21,3002)    (POWIP(J),J=1,NLAY)
      WRITE (21,'(A)') '=============================================='
      ENDIF
C***************************************************************
      IF (NPOLY.GT.0) THEN
      WRITE (21,'(A)') ' '
      WRITE (21,'(A)') '=============================================='
      WRITE (21,'(A)') '  >> THE POLYGONAL TX LOOP BLOCK <<'
      WRITE (21,'(A)') '=============================================='
      WRITE (21,'(A)') ' NPOLY:'
      WRITE (21,3000)    NPOLY
      WRITE (21,'(A)') ' X-COORDINATES OF APICES:'
      WRITE (21,3002)    (XPOLY(J),J=1,NPOLY)
      WRITE (21,'(A)') ' Y-COORDINATES OF APICES:'
      WRITE (21,3002)    (YPOLY(J),J=1,NPOLY)
      WRITE (21,'(A)') ' X-, Y-, AND Z-COORDINATES OF RX:'
      WRITE (21,3002)    X0RX,Y0RX,Z0RX
      WRITE (21,'(A)') '=============================================='
      ENDIF
C***************************************************************
      WRITE (21,'(A)') ' '
      WRITE (21,'(A)') '=============================================='
      WRITE (21,'(A)') '  >> THE RESPONSE BLOCK <<'
      WRITE (21,'(A)') '=============================================='
      WRITE (21,'(A)') ' IRESPTYPE,IDERIV,IREP,IWCONV,NFILT:'
      WRITE (21,3000)    IRESPTYPE,IDERIV,IREP,IWCONV,NFILT
      WRITE (21,'(A)') ' REPFREQ,(FILTFREQ(J),J=1,NFILT):'
      WRITE (21,3002)    REPFREQ,(FILTFREQ(J),J=1,NFILT)
      WRITE (21,'(A)') '=============================================='

 3000 FORMAT (12(2X,I3))
 3001 FORMAT (30(2X,1PE11.4))
 3002 FORMAT (30(2X,F10.2))
C***************************************************************

      WRITE (21,'(A)') ' '
      WRITE (21,'(A)') ' '
      WRITE (21,'(A)')
     # '=============================================================='
      WRITE (21,'(A)') ' NUMBER   TIME       RESP         DERIV'
      WRITE (21,'(A)')
     # '=============================================================='

      IF (IDERIV.EQ.0) THEN
      DO I = 1,NTOUT
        WRITE (21,3003) I,TIMESOUT(I),RESPOUT(I)
      ENDDO
      ENDIF

 3003 FORMAT (I3,20(2X,1PE11.4))

      IF (IDERIV.GT.0) THEN

        IF (IMLM.EQ.1) THEN
          NPARM = NLAY+1
        ELSEIF (IMLM.EQ.0) THEN
          NPARM = NLAY + (NLAY-1) + 1
        ENDIF

      DO I = 1,NTOUT
        WRITE (21,3003)
     #   I,TIMESOUT(I),RESPOUT(I),(DRESPOUT(I,J),J=1,NPARM)
      ENDDO

      WRITE (21,'(A)')
     # '=============================================================='

      ENDIF

      ENDIF
C --- ENDIF: WRITING TO UNIT 21

C========================================================================
C --- WRITE TO OUTPUT FILE: FORWRITE, IN SIMPLE FORMAT, UNIT=8
C========================================================================

C............................................................
      IF (IWRI.EQ.1) THEN
      WRITE (*,*) 'WRITING RESPONSES TO FORWRITE'
      ENDIF
C............................................................

      WRITE (8,3004) (TIMESOUT(I),I=1,NTOUT)
      WRITE (8,3004) (RESPOUT(I),I=1,NTOUT)

      IF (IDERIV.GT.0) THEN
        DO J = 1,NPARM
        WRITE (8,3004) (DRESPOUT(I,J),I=1,NTOUT)
        ENDDO
      ENDIF

 3004 FORMAT (128(2X,1PE11.4))
C========================================================================

 1010 FORMAT ( 2(2X,1PE11.4))
 1011 FORMAT (35(2X,1PE11.4))

C======================================================================
C --- Close the open input file and the UNNIT=21 file.
C --- Output comes to the output file from the TEM1D routine.
C======================================================================
C      CLOSE (7)
C      CLOSE (8)
C      CLOSE (21)

      STOP

      END

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
C   F U N C T I O N    S T I M E R
C
C   Function STIMER returns the monitor time value in seconds.
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      REAL*8 FUNCTION STIMER(DUMMY)
C ----------
      INTEGER*2 IH,IM,IS,IS100
C ----------

      CALL GETTIM(IH,IM,IS,IS100)
      STIMER=IH*3600.D0+IM*60.D0+IS+IS100/100.D0

      RETURN
      END
