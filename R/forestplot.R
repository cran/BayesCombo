#' @title Forest plot
#'
#' @description Plots the effect sizes and standard errors for a set of studies
#' as a standard forest plot. Also shown are the priors for each study.
#'
#' @details This function plots results from the \code{ev.combo()} function. The
#' results may be hard to visualise if the effect sizes differ greatly, and it
#' may be preferable to standardise the effect sizes by setting \code{scale =
#' TRUE} in the \code{ev.combo()} function.
#'
#' @param x An object of the class \code{EV}.
#' 
#' @param range A numeric vector of length two that sets the range of the
#' x-axis. Values are passed to \code{xlim}. Sensible default values are used
#' when \code{range = NULL}.
#'
#' @param xlab,ylab Text for the x and y axes labels.
#'
#' @param labels Names for studies to be plotted on the y-axis. If \code{NULL},
#' then numbers are used.
#' 
#' @param ...  Other options passed to \code{plot()}.
#' 
#' @return A forest plot.
#'
#' @seealso \code{\link{ev.combo}}
#'
#' @export
#'
#' @examples
#' x <- ev.combo( beta = c(0.0126, 5.0052, 1.2976, 0.0005),
#'        se.beta = c(0.050, 2.581, 2.054, 0.003) )
#' forestplot(x)
#'
forestplot <- function(x, range=NULL, xlab="Effect size", ylab="Study",
                       ..., labels=NULL) {
    
    if (!inherits(x, "EV")){
        stop("Input must be a 'EV' object from the ev.combo() function.")
    }

    # multiplier for confidence intervals
    ci <- (x$ci / 100)
    ci <- ci + (1 - ci) / 2
    multiplier <- qnorm(ci)

    # calclate x-axis range
    if (is.null(range)){
        xlim <- c(min(x$beta0 - x$se0 * multiplier),
                  max(x$beta0 + x$se0 * multiplier))
    } else {
        xlim <- c(range[1], range[2])
    }

    # setup plot
    old.par <- par(no.readonly = TRUE)
    par(las=1)
    
    plot(c(1:x$N) ~ x$beta, type="n", yaxt="n", xlab = xlab, ylab = ylab,
         xlim = xlim, ...)
    if (is.null(labels)) { 
        axis(2, at=1:x$N)
    } else {
        axis(2, at=1:x$N, labels=labels)
    }

    # priors
    segments(rep(x$beta0, x$N) - x$se0 * multiplier, 1:x$N,
             rep(x$beta0, x$N) + x$se0 * multiplier, 1:x$N,
             lwd=6, col="darkgrey")

    # data
    arrows(x$beta - x$se.beta * multiplier, 1:x$N,
           x$beta + x$se.beta * multiplier, 1:x$N,
           code=3, angle=90, length=0.05)

    points(c(1:x$N) ~ x$beta, pch=18, cex=1.2)

    on.exit(par(old.par))
}
