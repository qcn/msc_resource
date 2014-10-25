library("pls")

args<-commandArgs(TRUE)

allf0data = read.table('all_transformed.f0', header=TRUE);
# in these files we go tone1..tone5 spk1..8 s1..s30
zerorows = apply(allf0data[14:43], 1, min)==0; # indices depend on data file
f0data = allf0data[!zerorows,]

correct = 0
correct_fp = 0
incorrect_fp = 0
incorrect_nothing= 0
ft_correct = 0
ft_incorrect = 0
score = 0

eps = 1.0

truetone = FALSE
falsepos = 0

threshold = args[1]


# use a leave-one-out method: train on all but one sample
numsamples = nrow(f0data)

cat(sprintf("running on %d samples\n", numsamples, eps))

train = f0data # train on everything
# train a model
dataframe = data.frame(tones=I(as.matrix(train[,1:5])), obs=I(as.matrix(train[,6:43])))
cat(sprintf("training model...\n"))
model = plsr(tones~obs, data=dataframe, validation="CV")
cat(sprintf("trained model...\n"))

for (i in 1:numsamples) {

    truetone = FALSE
    falsepos = 0
    falseneg = FALSE
    failed_threshold = FALSE

    test = f0data[i,]

    # use the model to predict
    new = predict(model, ncomp=model$ncomp, newdata=as.matrix(test[6:43])) # use same number of components as the cross-validated model
#    new = predict(model, ncomp=3, newdata=as.matrix(test[6:43])) # use a small number of components
    # test the result
    closest_t1 = floor(new[[1]]+0.5) # round it to an integer
    closest_t2 = floor(new[[2]]+0.5) # round it to an integer
    closest_t3 = floor(new[[3]]+0.5) # round it to an integer
    closest_t4 = floor(new[[4]]+0.5) # round it to an integer
    closest_t5 = floor(new[[5]]+0.5) # round it to an integer

    result_vector = new
    rounded_result_vector = c(closest_t1, closest_t2, closest_t3, closest_t4, closest_t5)
    actual_vector = test[1:5]
    this_score = sqrt(sum((rounded_result_vector-result_vector)^2))
    score = score + this_score
    
    if (this_score > threshold) {
        failed_threshold = TRUE
    }

    if (closest_t1 >= 1) { # to allow for things getting rounded up to 2, or something
        if (test[[1]] == 1) {
            truetone = TRUE # true positive
        }
        else {
            falsepos = falsepos + 1 # false positive
        }
    }
    else {
        if (test[[1]] == 1) { # false negative
            falseneg = TRUE
        }
    }
    
    if (closest_t2 >= 1) {
        if (test[[2]] == 1) {
            truetone = TRUE # true positive
        }
        else {
            falsepos = falsepos + 1 # false positive
        }
    }
    else {
        if (test[[2]] == 1) { # false negative
            falseneg = TRUE
        }
    }
    
    if (closest_t3 >= 1) {
        if (test[[3]] == 1) {
            truetone = TRUE # true positive
        }
        else {
            falsepos = falsepos + 1 # false positive
        }
    }
    else {
        if (test[[3]] == 1) { # false negative
            falseneg = TRUE
        }
    }
    
    if (closest_t4 >= 1) {
        if (test[[4]] == 1) {
            truetone = TRUE # true positive
        }
        else {
            falsepos = falsepos + 1 # false positive
        }
    }
    else {
        if (test[[4]] == 1) { # false negative
            falseneg = TRUE
        }
    }
    
    if (closest_t5 >= 1) {
        if (test[[5]] == 1) {
            truetone = TRUE # true positive
        }
        else {
            falsepos = falsepos + 1 # false positive
        }
    }
    else {
        if (test[[5]] == 1) { # false negative
            falseneg = TRUE
        }
    }

    if (failed_threshold == TRUE) {
        if (truetone == TRUE && falsepos == 0) { # correct, failed threshold
            cat(sprintf("sample %d correct/failed threshold", i))
            ft_correct = ft_correct + 1
        }
        else {
            cat(sprintf("sample %d incorrect/failed threshold", i))
            ft_incorrect = ft_incorrect + 1
        }
    }
    else {

        if (truetone == TRUE && falsepos == 0) { # correct tone, no others selected
            cat(sprintf("sample %d correct", i))
            correct = correct + 1
        }
        if (truetone == TRUE && falsepos > 0) { #correct tone, but others selected
            cat(sprintf("sample %d correct with %d false positives", i, falsepos))
            correct_fp = correct_fp + 1
        }
        if (truetone == FALSE && falsepos > 0) { # correct tone not selected, others selected
            cat(sprintf("sample %d tone not detected, %d false positives", i, falsepos))
            incorrect_fp = incorrect_fp + 1
        }
        if (truetone == FALSE && falsepos == 0) { # nothing detected
            cat(sprintf("sample %d no tones detected", i))
            incorrect_nothing = incorrect_nothing + 1
        }
    }

    cat(sprintf(", score = %f\n", this_score))
    
    

}

print("Samples: ")
print(numsamples)

print("Threshold: ")
print(threshold)

print("Correct (no extra selections): ")
print(correct)

print("Correct tone selected, with extra selections: ")
print(correct_fp)

print("Incorrect tones selected: ")
print(incorrect_fp)

print("Nothing selected: ")
print(incorrect_nothing)

print("Failed threshold/correct: ")
print(ft_correct)

print("Failed threshold/incorrect: ")
print(ft_incorrect)

print("Model score: ")
print(score)
