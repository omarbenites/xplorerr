observe({
  updateSelectInput(session,inputId = "var_levtest",
    choices = names(data()), selected = '')
  updateSelectInput(session,inputId = "var_levtestg1",
    choices = names(data()), selected = '')
  updateSelectInput(session,inputId = "var_levtestg2",
    choices = names(data()), selected = '')
})

observeEvent(input$button_split_no, {
    f_data <- final_split$train[, sapply(final_split$train, is.factor)]
    num_data <- final_split$train[, sapply(final_split$train, is.numeric)]
    if (is.null(dim(num_data))) {
            k <- final_split$train %>% map(is.numeric) %>% unlist()
            j <- names(which(k == TRUE))
            numdata <- tibble::as_data_frame(num_data)
            colnames(numdata) <- j
            updateSelectInput(session, 'var_levtest',
              choices = names(numdata), selected = names(numdata))
            updateSelectInput(session, 'var_levtestg1',
              choices = names(numdata), selected = names(numdata))
        } else if (ncol(num_data) < 1) {
             updateSelectInput(session, 'var_levtest',
              choices = '', selected = '')
             updateSelectInput(session, 'var_levtestg1',
              choices = '', selected = '')
        } else {
             updateSelectInput(session, 'var_levtest', choices = names(num_data))
             updateSelectInput(session, 'var_levtestg1', choices = names(num_data))
        }
    if (is.null(dim(f_data))) {
        k <- final_split$train %>% map(is.factor) %>% unlist()
        j <- names(which(k == TRUE))
        fdata <- tibble::as_data_frame(f_data)
        colnames(fdata) <- j
        updateSelectInput(session, inputId = "var_levtestg2",
            choices = names(fdata))
        } else {
          updateSelectInput(session, 'var_levtestg2', choices = names(f_data))
        }
})


observeEvent(input$submit_part_train_per, {
    f_data <- final_split$train[, sapply(final_split$train, is.factor)]
    num_data <- final_split$train[, sapply(final_split$train, is.numeric)]
    if (is.null(dim(num_data))) {
            k <- final_split$train %>% map(is.numeric) %>% unlist()
            j <- names(which(k == TRUE))
            numdata <- tibble::as_data_frame(num_data)
            colnames(numdata) <- j
            updateSelectInput(session, 'var_levtest',
              choices = names(numdata), selected = names(numdata))
            updateSelectInput(session, 'var_levtestg1',
              choices = names(numdata), selected = names(numdata))
        } else if (ncol(num_data) < 1) {
             updateSelectInput(session, 'var_levtest',
              choices = '', selected = '')
             updateSelectInput(session, 'var_levtestg1',
              choices = '', selected = '')
        } else {
             updateSelectInput(session, 'var_levtest', choices = names(num_data))
             updateSelectInput(session, 'var_levtestg1', choices = names(num_data))
        }
    if (is.null(dim(f_data))) {
        k <- final_split$train %>% map(is.factor) %>% unlist()
        j <- names(which(k == TRUE))
        fdata <- tibble::as_data_frame(f_data)
        colnames(fdata) <- j
        updateSelectInput(session, inputId = "var_levtestg2",
            choices = names(fdata))
        } else {
          updateSelectInput(session, 'var_levtestg2', choices = names(f_data))
        }
})


d_levtest <- eventReactive(input$submit_levtest, {
  req(input$var_levtest)
	# validate(need((input$var_levtest != ''), 'Please select variables'))
  data <- final_split$train[, c(input$var_levtest)]
  out <- levene_test(data)
  out
})

d_levtestg <- eventReactive(input$submit_levtestg, {
  req(input$var_levtestg1)
  req(input$var_levtestg2)
	# validate(need((input$var_levtestg1 != '' & input$var_levtestg2 != ''), 'Please select variables'))
  data <- final_split$train[, c(input$var_levtestg1, input$var_levtestg2)]
  out <- levene_test(data[, 1], group_var = data[, 2])
  out
})

d_levmod <- eventReactive(input$submit_levtestf, {
  req(input$levtest_fmla)
  # validate(need((input$levtest_fmla != ''), 'Please specify a model'))
  data <- final_split$train
  k <- lm(input$levtest_fmla, data = data)
  out <- levene_test(k)
  out
})

output$levtest_out <- renderPrint({
  d_levtest()
})

output$levtestg_out <- renderPrint({
  d_levtestg()
})

output$levtestf_out <- renderPrint({
  d_levmod()
})
