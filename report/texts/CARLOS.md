\section{Predictive Forecasting}
\label{sec:predictive_forecasting}

\subsection{Ten-Year Projections}
\label{sec:projections}

\noindent
Based on the evidence from our Bayesian model comparison in \ref{sec:model_comparison}, which strongly favors the quadratic trend model, we have projected annual atmospheric $CO_2$ concentrations for the next decade (2026--2036). The quadratic fit confirms that $CO_2$ accumulation is not merely constant but compounding. As illustrated in Figure \ref{fig:co2_forecast}, the projected trajectory maintains the observed upward curvature, indicating that the annual rate of $CO_2$ increase is expected to grow over the next ten years.

\subsection{Uncertainty Quantification}
\label{sec:uncertainty}

\noindent
To quantify forecast uncertainty, we derived 95\% credible bands from the posterior predictive distribution. These bands were calculated by drawing 1,000 samples from the joint posterior distribution of the model parameters ($\beta_0, \beta_1, \beta_2$) and the residual variance. For each year in the forecast horizon, we computed the regression $\mu(t) = \beta_0 + \beta_1 t + \beta_2 t^2$ across all posterior draws, determining the 2.5th and 97.5th percentiles to define the credible interval. These bands represent the range within which the true underlying mean $CO_2$ trend is expected to lie with 95\% probability. As seen in Figure \ref{fig:co2_forecast}, the width of these bands increases slightly over time, reflecting the propagation of parameter uncertainty into future projections.

% --- Figure for Forecasting --- ALVARO, WRITE THE FILEPATH HERE FOR THE OUTPUT
\begin{figure}[H]
    \centering
    \includegraphics[width=0.8\textwidth]{forecast_plot.png}
    \caption{Mauna Loa $CO_2$ Bayesian Quadratic Forecast. The plot displays the historical yearly averages (red dots), the quadratic model fit (solid green line), and the 10-year projection (dashed green line) with 95\% credible bands (shaded region).}
    \label{fig:co2_forecast}
\end{figure}

% --- Section 6: Conclusion ---
\section{Conclusion}
\label{sec:conclusion}

\subsection{Summary of Findings}
\label{sec:findings}

\noindent
Our analysis confirms that the quadratic model significantly outperforms the linear model in capturing the historical $CO_2$ accumulation at Mauna Loa. The 10-year projections, based on the quadratic trend, indicate that atmospheric $CO_2$ will continue to rise at an accelerating rate. These results highlight the non-linear nature of anthropogenic $CO_2$ accumulation and reinforce the urgency of addressing compounding emissions.

\subsection{Limitations and Future Work}
\label{sec:limitations}

While our model robustly captures the historical trend, several limitations should be noted. First, the quadratic model assumes that the current acceleration will persist indefinitely, which may not account for future policy-driven changes in emission rates. Second, the convergence diagnostics (specifically the occurrence of divergent transitions during Stan sampling) suggest that future work could improve model stability by using more informative priors or non-centered parameterizations.