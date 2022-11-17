const gulp = require('gulp'),
  postcss = require('gulp-postcss'),
  browserSync = require('browser-sync').create(),
  autoprefixer = require('autoprefixer');

const sass = require('gulp-sass')(require('node-sass'));
const cleanCSS = require('gulp-clean-css');

const paths = {
  styles: {
    src: 'scss/*.scss',
    dest: 'css/',
  },
  html: {
    src: './*.html',
  },
};

function styles() {
  return gulp
    .src(paths.styles.src)
    .pipe(sass())
    .pipe(postcss([autoprefixer()]))
    .pipe(gulp.dest(paths.styles.dest))
    .pipe(browserSync.stream());
}

function watchChanges() {
  browserSync.init({
    server: '.',
    ui: false,
    port: 3000,
  });

  gulp.watch('scss/**/*.scss', styles);
  gulp.watch(paths.html.src).on('change', browserSync.reload);
}

gulp.task('minify-css', () => {
  return gulp
    .src(paths.styles.dest + '*.css')
    .pipe(cleanCSS({ compatibility: 'ie8' }))
    .pipe(gulp.dest(paths.styles.dest));
});

gulp.task('sass', styles);
gulp.task('serve', gulp.series('sass', watchChanges));
gulp.task('build', gulp.series('sass', 'minify-css'));
