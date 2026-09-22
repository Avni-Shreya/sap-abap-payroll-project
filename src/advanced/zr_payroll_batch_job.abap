*&---------------------------------------------------------------*
*& Report ZR_PAYROLL_BATCH_JOB
*&---------------------------------------------------------------*
*& Purpose : Demonstrates background job scheduling - running the
*&           payslip generation for ALL employees as a periodic
*&           batch job instead of one-by-one via ZR_PAYSLIP_DRIVER.
*&---------------------------------------------------------------*
REPORT zr_payroll_batch_job.

PARAMETERS: p_sched AS CHECKBOX.  " tick to actually schedule the job

DATA: lv_jobname  TYPE tbtcjob-jobname VALUE 'ZPAYROLL_MONTHLY_RUN',
      lv_jobcount TYPE tbtcjob-jobcount,
      lv_print    TYPE pri_params.

START-OF-SELECTION.

  IF p_sched = abap_true.

    " 1. Open a background job
    CALL FUNCTION 'JOB_OPEN'
      EXPORTING
        jobname          = lv_jobname
      IMPORTING
        jobcount         = lv_jobcount
      EXCEPTIONS
        cant_create_job  = 1
        invalid_job_data = 2
        jobname_missing  = 3
        OTHERS           = 4.

    IF sy-subrc <> 0.
      MESSAGE 'Could not open job' TYPE 'E'.
    ENDIF.

    " 2. Submit the actual payslip program to run under this job
    SUBMIT zr_payslip_batch_all
      VIA JOB lv_jobname NUMBER lv_jobcount
      AND RETURN.

    " 3. Close and schedule the job to run monthly on the 1st at 02:00
    CALL FUNCTION 'JOB_CLOSE'
      EXPORTING
        jobcount             = lv_jobcount
        jobname               = lv_jobname
        sdlstrtdt             = sy-datum
        sdlstrttm             = '020000'
        strtimmed             = abap_false
        prddays               = 1
        prdmonths             = 1
        periodic              = abap_true
      EXCEPTIONS
        cant_start_immediate = 1
        invalid_startdate    = 2
        jobname_missing      = 3
        job_close_failed     = 4
        job_nosteps          = 5
        job_notex             = 6
        lock_failed           = 7
        OTHERS                = 8.

    IF sy-subrc = 0.
      MESSAGE 'Monthly payroll batch job scheduled successfully' TYPE 'S'.
    ELSE.
      MESSAGE 'Job scheduling failed' TYPE 'E'.
    ENDIF.

  ELSE.
    WRITE: / 'Tick the checkbox to schedule the monthly payroll job.'.
  ENDIF.

*&---------------------------------------------------------------*
*& Companion program ZR_PAYSLIP_BATCH_ALL (referenced above) would
*& loop over every active employee and call the ZSF_PAYSLIP Smart
*& Form for each one - same logic as ZR_PAYSLIP_DRIVER, but driven
*& by a SELECT * FROM zemp_master instead of a single PARAMETER.
*&---------------------------------------------------------------*
